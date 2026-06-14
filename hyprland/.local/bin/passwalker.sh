#!/usr/bin/env zsh

DIR=~/.password-store

BASE=$(find "$DIR" -maxdepth 1 -mindepth 1 ! -name '.*' -printf '%f\n' | walker -d) || exit 1
NAME=$(find "${DIR}/${BASE}" -maxdepth 1 -mindepth 1 ! -name '.*' -printf '%f\n' | sed 's/\.[^.]*$//' | walker -d) || exit 1

SECRET="${BASE}/${NAME}"

pass "$SECRET" -c

notify-send -i dialog-password -u low "Password Copied" "${SECRET}" -t 2000
