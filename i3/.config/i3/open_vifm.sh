#!/usr/bin/zsh

tmux a -t files || tmux new-session -s files 'vifm'
