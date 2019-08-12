#!/bin/bash
tmux attach -t spotify || tmux new-session -s "spotify" ncspot #&& tmux attach -t spotify
