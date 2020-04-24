#!/usr/bin/env bash
export NOTMUX=1

terminal=$(echo -e 'kitty\ntermite\nurxvtc\nst' | dmenu)

status=$?

if test $status -eq 0
then
        exec $terminal
fi
