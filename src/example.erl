%% -------------------------------------------------------------------
%%
%% euc_tutorial: 
%%
%% Copyright (c) 2014 Basho Technologies Inc.  All Rights Reserved.
%%
%% This file is provided to you under the Apache License,
%% Version 2.0 (the "License"); you may not use this file
%% except in compliance with the License. You may obtain
%% a copy of the License at
%%
%%   http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing,
%% software distributed under the License is distributed on an
%% "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
%% KIND, either express or implied.  See the License for the
%% specific language governing permissions and limitations
%% under the License.
%%
%% -------------------------------------------------------------------

-module(example).

-export([run/0]).

run() ->
    lager:info("started example"),
Reading = riakc_map:new(),

lager:info("Reading : ~p ",[Reading]),

Reading1 = riakc_map:update({<<"ReaderName322323">>, register}, fun(R) -> riakc_register:set(<<0,0,31,64>>, R) end, Reading),
 
lager:info("Reading1 : ~p ",[Reading1]),

Reading2 = riakc_map:new(),


lager:info("Reading2 : ~p ",[Reading2]),

Reading3 = riakc_map:update({<<"ReaderName5555">>, register}, fun(R) -> riakc_register:set(<<0,0,31,65>>, R) end, Reading2),
 
lager:info("Reading3 : ~p ",[Reading3]),

%% Start connection to riak.
{ok, Pid} = riakc_pb_socket:start("localhost", 10017),

%% Write to riak no need to read first.
%% {Bucket Type, Bucket}
riakc_pb_socket:update_type(Pid,{<<"maps">>, <<"maps">>}, <<"AccountNameTimeStamp">>, riakc_map:to_op(Reading1)),

riakc_pb_socket:update_type(Pid,{<<"maps">>, <<"maps">>}, <<"AccountNameTimeStamp">>, riakc_map:to_op(Reading3)),

%% Get result from riak.
{ok, Results} = riakc_pb_socket:fetch_type(Pid, {<<"maps">>, <<"maps">>}, <<"AccountNameTimeStamp">>),


lager:info("Results: ~p ",[Results]),


%% {ok,{map,[{{<<"ReaderName322323">>,register},<<0,0,31,64>>},
%%           {{<<"ReaderName5555">>,register},<<0,0,31,65>>}],
%% 
%%          [],[],
%%          <<131,108,0,0,0,2,104,2,109,0,0,0,8,191,234,133,31,83,
%%            206,54,132,97,...>>}}

ReaderName322323 = riakc_map:fetch({<<"ReaderName322323">>, register}, Results),

lager:info("ReaderName322323: ~p ",[Results]),

%% <<0,0,31,64>>
riakc_map:fetch({<<"ReaderName5555">>, register}, Results),


lager:info("ReaderName5555 : ~p ",[Results]),

lager:info("finished").
