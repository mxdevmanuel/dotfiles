#!/usr/bin/env bash


SELECT_MENU=${EMOJI_SELECT_MENU:-rofi -dmenu -i -p unicode -kb-custom-1 Ctrl+c}
COPY_TOOL=${EMOJI_COPY_TOOL:-xclip -selection clipboard -i}

# Where to save the symbols file.
SYMBOLS_FILE=$HOME/.local/share/unicode/symbols


function display() {
    symbols=$(cat "$SYMBOLS_FILE")
    line=$(echo "$symbols" | $SELECT_MENU  $@)
    exit_code=$?

    line=($line)

    if [ $exit_code == 0 ]; then
        echo -n "${line[0]}" | sed -E 's/^(.).*/\1/g' | $COPY_TOOL
    fi
}

# display displays :)
display
