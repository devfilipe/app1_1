%%%-------------------------------------------------------------------
%% @doc app1_1 top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(app1_1_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%% sup_flags() = #{strategy => strategy(),         % optional
%%                 intensity => non_neg_integer(), % optional
%%                 period => pos_integer()}        % optional
%% child_spec() = #{id => child_id(),       % mandatory
%%                  start => mfargs(),      % mandatory
%%                  restart => restart(),   % optional
%%                  shutdown => shutdown(), % optional
%%                  type => worker(),       % optional
%%                  modules => modules()}   % optional
init([]) ->
    SupFlags = #{strategy => one_for_all,
                 intensity => 0,
                 period => 1},
    Restart = permanent,
    Shutdown = 2000,
    Type = worker,
    AChild = {'app1_1', {'app1_1', start_link, []},
               Restart, Shutdown, Type, ['app1_1']},
    ChildSpecs = [AChild],
    {ok, {SupFlags, ChildSpecs}}.

%% internal functions
