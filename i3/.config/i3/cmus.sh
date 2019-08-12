#!/bin/bash
tmux attach -t cmus || tmux new-session -d -s "cmus" cmus && tmux attach -t cmus
