-module(main).
-export([main/1, fork_ready/0, fork_empty/0, philosopher/3]).

fork_ready() ->
    receive
        {take, Pid} ->
            Pid ! give,
            fork_empty()
    end.

fork_empty() ->
    receive
        replace -> fork_ready()
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

repeat(0, _) -> nil;
repeat(N, F) ->
    F(),
    repeat(N - 1, F).

main(_) ->
    Fork0 = spawn(main, fork_ready, []),
    Fork1 = spawn(main, fork_ready, []),
    Fork2 = spawn(main, fork_ready, []),
    Fork3 = spawn(main, fork_ready, []),
    Fork4 = spawn(main, fork_ready, []),
    spawn(main, philosopher, [Fork0, Fork1, self()]),
    spawn(main, philosopher, [Fork1, Fork2, self()]),
    spawn(main, philosopher, [Fork2, Fork3, self()]),
    spawn(main, philosopher, [Fork3, Fork4, self()]),
    spawn(main, philosopher, [Fork0, Fork4, self()]),
    repeat(5, fun() ->
        receive
            _ -> nil
        end
    end),
    io:format("Done!~n").
