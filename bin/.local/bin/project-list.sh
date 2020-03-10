#!/usr/bin/env zsh
CODE_DIR=~/Code
export NOTMUX=1
export FORCE_DARK=1
if [[ ! -z "$NVIMGUI" ]]
then
        COMMAND="nvim-qt"
else
        COMMAND="st -e vim"
fi
find $CODE_DIR -maxdepth 1 -type d  | rofi -dmenu -matching fuzzy | xargs -I%  zsh -i -c "cd % && $COMMAND & ; exit " > /dev/null 2>&1
