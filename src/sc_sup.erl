-module(sc_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
%-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 2000, Type, [I]}).

-define(SERVER, ?MODULE).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).


%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    ElementSup = {sc_element_sup, {sc_element_sup, start_link, []},
		  permanent, 2000, supervisor, [sc_element]},

    EventManager = {sc_event, {sc_event, start_link, []},
		    permanent, 2000, worker, [sc_event]},

    Children = [ElementSup, EventManager],
    RestartStrategy = {one_for_one, 4, 3600},
    
    {ok, {RestartStrategy, Children}}.

