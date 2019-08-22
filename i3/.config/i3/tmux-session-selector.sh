#!/bin/bash
tmux ls | perl -pe 's/:.*$//' | dmenu | xargs -I% termite -e "tmux a -t '%'"

