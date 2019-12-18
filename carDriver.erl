-module(carDriver).
-export([getNewCarToWash/0]).
-export([requestCarWash/0, leaveCarWash/0]).
-export([initCar/0]).

getNewCarToWash() ->
	 Pid = spawn(?MODULE, initCar, []),
	 io:format("Car with pid ~p comes to car wash !~n", [Pid]).

initCar() -> 
	requestCarWash().
	
% carDriver interface --------------------------------------- //
% carDriver sends request to get to the car wash
requestCarWash() -> 
	io:format("Car with pid ~p request a car wash !~n", [Pid]).
    CarWashPid = whereis(carWashMutex),
	CarWashPid ! {request, self()},
    receive 
		ok -> ok 
	end.

% carDriver leaves the car wash
leaveCarWash() -> 
	io:format("Car with pid ~p leaves a car wash !~n", [Pid]).
    carWashMutex ! {leave, self()},
    ok.
% --------------------------------------------------------- //