%%%-----------------------------------------------------------------------------
%%% @copyright 2020-2020, PADTEC
%%% @doc Start first sentence in the same line as `@doc' ending with dot and empty
%%% comment line.
%%%
%%% Write more doc here.
%%% @author Software Team
%%% @end
%%%-----------------------------------------------------------------------------
-module(app1_1).

-behaviour(gen_server).
%% API
-export([start_link/0, ping/1, pong/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-define(SERVER, ?MODULE).
-define(PEER, app1).

-record(state, {tref}).

-include_lib("eunit/include/eunit.hrl").

start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%% peer calls our to get pong
%%------------------------------------------------------------------------------
%% @doc Start first sentence in the same line as `@doc' ending with dot and empty
%%% comment line.
%%
%% For `Pid' description see erlang documentation.
%%
%% A link to a type {@link pid()}.
%%
%% @see pong/0
%% @end
%%------------------------------------------------------------------------------
ping(Pid) ->
  % code execution is in caller context
  % this server executes only handle_call()
  case gen_server:call(?SERVER, ping) of
    pong ->
      Pid ! pong,
      io:format("~p sending pong~n", [?SERVER]);
    _ ->
      io:format("~p failed processing ping~n", [?SERVER])
  end.

%% peer answers our ping by calling pong
pong() ->
  % if
  %   true ->
  %     io:format("~p got pong~n", [?MODULE]);
  %   true ->
  %     ok
  % end.
io:format("~p got pong~n", [?MODULE]).

%%------------------------------------------------------------------------------

init([]) ->
  % TRef = erlang:send_after(5000, ?SERVER, ping, []),
  % {ok, #state{tref = TRef}}
  {ok, #state{}}.

handle_call(ping, _From, State) ->
  Reply = pong,
  {reply, Reply, State};
handle_call(_Request, _From, State) ->
  Reply = ok,
  {reply, Reply, State}.

handle_cast(_Msg, State) ->
  {noreply, State}.

handle_info(ping, State) ->
  % note here we are calling a function from module app1
  % but code execution is in our context
  app1:ping(),
  timer:cancel(State#state.tref),
  TRef = erlang:send_after(5000, ?SERVER, ping, []),
  NewState = #state{tref = TRef},
  {noreply, NewState};
handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.


pong_test() ->
  ?assertMatch(ok, pong()).
