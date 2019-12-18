-module(carWashMutex).
-export([startCarWash/0, closeCarWash/0]).
-export([init/0]).

% register and start carWashMutex
startCarWash() -> 
    io:format("Starting car wash !~n"),
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
            Pid ! ok,       % send back approval
            busy(Pid);      % car wash is busy now...
        close -> 
            close()         % close car wash
    end.
    
% car is currently in car wash and the car wash
% waits for the car to leave 
busy(Pid) -> 
    receive 
        {leave, Pid} -> 
            free()
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