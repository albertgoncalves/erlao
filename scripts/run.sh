#!/usr/bin/env bash

set -eu

if [ ! -d "$WD/build" ]; then
    mkdir "$WD/build"
fi

cp "$1" "$WD/build/main.erl"
erlc -Wall -Werror -o "$WD/build" "+to_core" "$WD/build/main.erl"
erlc -o "$WD/build" -b beam "+from_core" "$WD/build/main.core"
escript "$WD/build/main.beam"
