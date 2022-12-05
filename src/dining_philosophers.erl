-module(main).
-export([main/1, fork/1, philosopher/3]).

fork(Ready) ->
    if Ready ->
        receive
            {take, Pid} ->
                Pid ! give,
                fork(false)
        end;
    true ->
        receive
            replace -> fork(true)
        end
    end.

philosopher(ForkLeft, ForkRight, Done) ->
    io:format(" [~p] request left fork~n", [self()]),
    ForkLeft ! {take, self()},
    receive
        give -> io:format(" [~p] receive left fork~n", [self()])
    end,

    io:format(" [~p] request right fork~n", [self()]),
    ForkRight ! {take, self()},
    receive
        give -> io:format(" [~p] receive right fork~n", [self()])
    end,

    io:format(" [~p] dining~n", [self()]),
    timer:sleep(250),

    io:format(" [~p] return left fork~n", [self()]),
    ForkLeft ! replace,

    io:format(" [~p] return right fork~n", [self()]),
    ForkRight ! replace,

    Done ! nil,

    io:format(" [~p] thinking~n", [self()]),
    timer:sleep(250).

main(_) ->
    Fork0 = spawn(main, fork, [true]),
    Fork1 = spawn(main, fork, [true]),
    Fork2 = spawn(main, fork, [true]),
    Fork3 = spawn(main, fork, [true]),
    Fork4 = spawn(main, fork, [true]),
    spawn(main, philosopher, [Fork0, Fork1, self()]),
    spawn(main, philosopher, [Fork1, Fork2, self()]),
    spawn(main, philosopher, [Fork2, Fork3, self()]),
    spawn(main, philosopher, [Fork3, Fork4, self()]),
    spawn(main, philosopher, [Fork0, Fork4, self()]),
    receive
        _ -> nil
    end,
    receive
        _ -> nil
    end,
    receive
        _ -> nil
    end,
    receive
        _ -> nil
    end,
    receive
        _ -> nil
    end,
    io:format("Done!~n").
