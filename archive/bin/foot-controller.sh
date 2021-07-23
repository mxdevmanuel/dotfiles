#/usr/bin/env bash

focused_id=$(xdotool getwindowfocus)
focused_pid=$(xdotool getwindowpid $focused_id)
focused_info=$(ps -e | grep $focused_pid)

video_regex='chrom|vlc'
if [[ $focused_info =~ $video_regex ]]
then
        notify-send "Video app"
        lock.sh
else
        notify-send "No action set" 
fi
