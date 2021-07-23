#!/usr/bin/env bash
export DISPLAY=:0
export XAUTHORITY=$HOME/.Xauthority
export XDG_RUNTIME_DIR=/run/user/$(id -u)

echo "Syncing lines"
local_path=$HOME/.lines 

if [[ ! -d $local_path ]]
then
        git clone $LINES_REPO $local_path
fi

cd $local_path

git pull

if [[ $? != 0 ]]
then
        notify-send "Lines" "Unable to pull lines, manual action required"
fi

git add .lines

git commit -m "Update $(date)"

git push

if [[ $? != 0 ]]
then
        notify-send "Lines" "Unable to push lines, manual action required"
fi
