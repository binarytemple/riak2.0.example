riak2.0.example
===============


#### Create and activate bucket type "maps"
```
riak-admin bucket-type create maps '{"props":{"datatype":"map"}}'

riak-admin bucket-type activate maps
```

More information on data types.
http://docs.basho.com/riak/2.0.0/dev/using/data-types/#Maps

 
```
Reading = riakc_map:new().
Reading1 = riakc_map:update({<<"ReaderName322323">>, register}, fun(R) -> riakc_register:set(<<0,0,31,64>>, R) end, Reading).
 
Reading2 = riakc_map:new().
Reading3 = riakc_map:update({<<"ReaderName5555">>, register}, fun(R) -> riakc_register:set(<<0,0,31,65>>, R) end, Reading2).
 
%% Start connection to riak.
{ok, Pid} = riakc_pb_socket:start("localhost", 8087).

 
%% Write to riak no need to read first.
%% {Bucket Type, Bucket}
riakc_pb_socket:update_type(Pid,{<<"maps">>, <<"maps">>}, <<"AccountNameTimeStamp">>, riakc_map:to_op(Reading1)).

riakc_pb_socket:update_type(Pid,{<<"maps">>, <<"maps">>}, <<"AccountNameTimeStamp">>, riakc_map:to_op(Reading3)).

%% Get result from riak.
{ok, Results} = riakc_pb_socket:fetch_type(Pid, {<<"maps">>, <<"maps">>}, <<"AccountNameTimeStamp">>).

%% {ok,{map,[{{<<"ReaderName322323">>,register},<<0,0,31,64>>},
%%           {{<<"ReaderName5555">>,register},<<0,0,31,65>>}],
%% 
%%          [],[],
%%          <<131,108,0,0,0,2,104,2,109,0,0,0,8,191,234,133,31,83,
%%            206,54,132,97,...>>}}

riakc_map:fetch({<<"ReaderName322323">>, register}, Results).

%% <<0,0,31,64>>
riakc_map:fetch({<<"ReaderName5555">>, register}, Results).

%% <<0,0,31,65>>
```
