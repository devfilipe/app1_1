%%%-------------------------------------------------------------------
%% @doc app1_1 public API
%% @end
%%%-------------------------------------------------------------------

-module(app1_1_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    app1_1_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
