#!/bin/bash
tmux ls | perl -pe 's/:.*$//' | dmenu | xargs -I% kitty /usr/bin/tmux a -t '%'

