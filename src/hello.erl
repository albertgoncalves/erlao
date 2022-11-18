-module(main).
-export([main/1, f/2]).

f(Pid, 0) -> Pid ! "Done!";
f(_, N) -> io:format("Hello, world! [~p]~n", [N]).

loop(_, 0) -> ok;
loop(Pid, N) ->
    M = N - 1,
    spawn(main, f, [Pid, M]),
    loop(Pid, M).

main(_) ->
    loop(self(), 1000),
    receive
        Message -> io:format("~s~n", [Message])
    end.
