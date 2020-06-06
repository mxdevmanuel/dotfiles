#!/usr/bin/env bash

echo "$@"
pkill -USR1 dunst
i3lock -n -c '#282828' -k --timecolor='#ebdbb2' --datecolor='#98971a' --pass-media-keys --pass-screen-keys "$@"
pkill -USR2 dunst
