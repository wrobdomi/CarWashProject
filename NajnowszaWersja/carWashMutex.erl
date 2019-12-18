-module(carWashMutex).
-export([startCarWash/0, closeCarWash/0]).
-export([init/0]).

% register and start carWashMutex
startCarWash() -> 
    io:format("CAR-WASH Starting car wash ~n"),
    Pid = spawn(?MODULE, init, []),
    register(carWashMutex, Pid).
	

% carWash closing ----------------------------------------- //
closeCarWash() -> 
    carWashMutex ! close.
% --------------------------------------------------------- //


% car wash is free initially
init() -> 
    free().

% car wash waits for clients to arrive...
free() -> 
    receive
        {request, Pid} ->   % give driver access to car wash
            io:format("CAR-WASH Car with ~p got a car wash. ~n", [Pid]),
			Pid ! ok,       % send back approval
            busy(Pid);      % car wash is busy now...
        close -> 
            close()         % close car wash
    end.
    
% car is currently in car wash and the car wash
% waits for the car to leave 
busy(Pid) -> 
	io:format("CAR-WASH MY PID IS ~p. ~n", [self()]),
    receive 
        {leave, Pid} -> 
            free();
		startWashingMachine ->
			io:format("CAR-WASH Car with ~p started timer. ~n", [Pid]),
			startTimer(),
			busy(Pid);
		endWashingMachine ->
			io:format("CAR-WASH Car with ~p ended timer. ~n", [Pid]),
			endTimer(),
			busy(Pid);
		{timestamp, Val} -> 
			io:format("CAR-WASH Timer sent me value ~p. ~n", [Val]),
			Pid ! {price, Val},
			busy(Pid)
    end.

% close car wash
close() ->
	receive
		{request, Pid} -> 
			exit(Pid, kill),
			close()
		after
			0 -> ok
    end.
	
startTimer() ->
	timer ! start.      
	
endTimer() -> 
	timer ! finish.