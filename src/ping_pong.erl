-module(main).
-export([main/1, ping_pong/2]).

ping_pong(Main_PID, Message) ->
    receive
        {N, Reply_PID} ->
            io:format("~s~n", [Message]),
            case N of
                0 -> Main_PID ! "Done!";
                N ->
                    Reply_PID ! {N - 1, self()},
                    ping_pong(Main_PID, Message)
            end
    end.

main(_) ->
    Ping_PID = spawn(main, ping_pong, [self(), "Ping"]),
    Pong_PID = spawn(main, ping_pong, [self(), "Pong"]),
    Ping_PID ! {5, Pong_PID},
    receive
        Message -> io:format("~s~n", [Message])
    end.
