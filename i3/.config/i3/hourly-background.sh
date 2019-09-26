#!/bin/bash
export DISPLAY=:0
export XAUTHORITY=/home/manuel/.Xauthority
export XDG_RUNTIME_DIR=/run/user/$(id -u)

exec /home/manuel/.config/i3/random_feh.sh
