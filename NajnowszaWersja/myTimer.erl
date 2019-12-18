-module(myTimer).
-export([createTimer/0]).
-export([startListening/1]).
-export([initTimer/0]).

% Set up timer
createTimer() -> 
    io:format("TIMER creating timer ~n"),
    Pid = spawn(?MODULE, initTimer, []),
    register(timer, Pid).
	
initTimer() -> 
	startListening(0).
	
startListening(StartTime) ->
	receive
		start ->
		    io:format("TIMER started... ~n"),
			startListening(os:system_time());
		finish ->
			io:format("TIMER finished... ~n"),
			carWashMutex ! {timestamp, (os:system_time()-StartTime)/1000},
			startListening(0)	
    end.