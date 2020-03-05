#!/usr/bin/env zsh
CODE_DIR=~/Code
export NOTMUX=1
export FORCE_DARK=1
find $CODE_DIR -maxdepth 1 -type d  | rofi -dmenu -matching fuzzy | xargs -I%  zsh -i -c "cd % && kitty -e vim " > /dev/null 2>&1
