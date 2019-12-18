-module(carDriver).
-export([getNewCarsToWash/0]).
-export([requestCarWash/0, leaveCarWash/0]).
-export([initCar/0]).

getNewCarsToWash() ->
	 Pid1 = spawn(?MODULE, initCar, []),
	 io:format("CAR with pid ~p comes to car wash !~n", [Pid1]).
	 % Pid2 = spawn(?MODULE, initCar, []),
	 % io:format("CAR with pid ~p comes to car wash !~n", [Pid2]),
	 % Pid3 = spawn(?MODULE, initCar, []),
	 % io:format("CAR with pid ~p comes to car wash !~n", [Pid3]),
	 % Pid4 = spawn(?MODULE, initCar, []),
	 % io:format("CAR with pid ~p comes to car wash !~n", [Pid4]).

initCar() -> 
	requestCarWash().
	 
% carDriver sends request to get to the car wash
requestCarWash() -> 
	io:format("CAR with pid ~p request a car wash !~n", [self()]),
    CarWashPid = whereis(carWashMutex),
	CarWashPid ! {request, self()},
    receive 
		ok -> 
			io:format("CAR car ~p starts washing machine... ~n", [self()]),
			startWashingMachine(),
			washCar()	
	end.
	
washCar() -> 
	io:format("CAR car ~p is washing... ~n", [self()]),
	timer:sleep(3000),
	stopWashingMachine(),
	receive
		{price, Value} -> 
			io:format("CAR I got price ~p ~n", [Value]),
			leaveCarWash()
	end.
	

% carDriver leaves the car wash
leaveCarWash() -> 
	io:format("CAR with pid ~p leaves a car wash !~n", [self()]),
    carWashMutex ! {leave, self()},
    ok.

% carDriver starts washing machine
startWashingMachine() -> 
	io:format("CAR with pid ~p starts a car wash !~n", [self()]),
    carWashMutex ! startWashingMachine,
    ok.
	
% carDriver starts washing machine
stopWashingMachine() -> 
	io:format("CAR with pid ~p stops a car wash !~n", [self()]),
    carWashMutex ! endWashingMachine,
    ok.