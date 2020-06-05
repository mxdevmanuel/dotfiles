#!/usr/bin/env bash

pkill -USR1 dunst
i3lock -n -c '#282828' -k --timecolor='#ebdbb2' --datecolor='#98971a' --pass-media-keys "$@"
pkill -USR2 dunst
