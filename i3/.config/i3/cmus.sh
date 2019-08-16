#!/bin/bash
tmux a -t cmus || tmux new-session -d -s "cmus" cmus && tmux a -t cmus
