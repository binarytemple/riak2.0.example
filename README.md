riak2.0.example
===============


#### Create and activate bucket type "maps"
```
sudo riak-admin bucket-type create maps '{"props":{"datatype":"map"}}'

sudo riak-admin bucket-type activate maps
```

More information on data types.
http://docs.basho.com/riak/2.0.0/dev/using/data-types/#Maps

```
./rebar_console
``` 
