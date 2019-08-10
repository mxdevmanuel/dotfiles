#!/bin/bash
tmux a -t cmus || tmux new-session -s "cmus" cmus
