-module(sc_element_sup).

-behaviour(supervisor).

%% API
-export([start_link/0,
        start_child/2]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, temporary, brutal_kill, Type, [I]}).

-define(SERVER, ?MODULE).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

start_child(Value, LeaseTime) ->
    supervisor:start_child(?SERVER, [Value, LeaseTime]).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    Element = ?CHILD(sc_element, worker),
    Children = [Element],
    RestartStrategy = {simple_one_for_one, 0, 1},
    
    {ok, {RestartStrategy, Children}}.

