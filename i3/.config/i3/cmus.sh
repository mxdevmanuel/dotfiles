#!/bin/bash
tmux attach -t cmus || tmux new-session -s "cmus" cmus
