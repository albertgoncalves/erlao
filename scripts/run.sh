#!/usr/bin/env bash

set -eu

if [ ! -d "$WD/build" ]; then
    mkdir "$WD/build"
fi

cp "$1" "$WD/build/main.erl"

# erlc -Wall -Werror -o "$WD/build" "+to_beam" "$WD/build/main.erl"

# erlc -Wall -Werror -o "$WD/build" "+to_core" "$WD/build/main.erl"
# erlc -o "$WD/build" -b beam "+from_core" "$WD/build/main.core"

erlc -Wall -Werror -o "$WD/build" -S "$WD/build/main.erl"
erlc -o "$WD/build" -b beam "+from_asm" "$WD/build/main.S"

escript "$WD/build/main.beam"
