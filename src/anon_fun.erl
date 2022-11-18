-module(main).
-export([main/1]).

f(X) -> X.

main(_) ->
    io:format("~p~n", [f(fun() -> A = 123, io:format("~p~n", [A]), A end())]).
