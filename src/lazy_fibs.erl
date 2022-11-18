% NOTE: See `https://github.com/treadup/erlang-echo-server/blob/master/echo.erl`.
% NOTE: See `https://8thlight.com/blog/kofi-gumbs/2017/05/02/core-erlang.html`.
% NOTE: See `https://baha.github.io/intro-core-erlang-2/`.
% NOTE: See `http://gomoripeti.github.io/beam_by_example/`.
% NOTE: See `https://www.it.uu.se/research/group/hipe/cerl/doc/core_erlang-1.0.3.pdf`.
% NOTE: See `https://www.erlang.org/blog/core-erlang-by-example/`.

-module(main).
-export([main/1]).

list(X, F) ->
    L = ets:new(?MODULE, [set]),
    ets:insert(L, {head, X}),
    ets:insert(L, {tail, fun() ->
        Y = F(),
        ets:insert(L, {tail, fun() -> Y end}),
        Y
    end}),
    L.

lookup(L, K) ->
    element(2, lists:nth(1, ets:lookup(L, K))).

drop(0, L) -> L;
drop(N, L) -> drop(N - 1, (lookup(L, tail))()).

zip_with(F, L0, L1) ->
    list(
        F(lookup(L0, head), lookup(L1, head)),
        fun() -> zip_with(F, (lookup(L0, tail))(), (lookup(L1, tail))()) end
    ).

main(_) ->
    T = ets:new(?MODULE, [bag]),
    ets:insert(T, {
        fibs,
        list(0, fun() ->
            list(1, fun() ->
                zip_with(
                    fun(A, B) -> A + B end,
                    lookup(T, fibs),
                    (lookup(lookup(T, fibs), tail))()
                )
            end)
        end)
    }),
    io:format("~w~n", [lookup(drop(45, lookup(T, fibs)), head)]).
