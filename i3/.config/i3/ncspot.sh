#!/bin/bash
tmux attach -t spotify || tmux new-session -d -s "spotify" ncspot && tmux attach -t spotify
