#!/usr/bin/env bash
SINK=$(pactl list short sinks | grep RUNNING | gawk '{print $1}') 

echo $SINK

if [ -z "$SINK" ]
then
        SINK=0
fi

if [ "$1" != "mute" ]
then
        pactl set-sink-volume $SINK $1
else
        pactl set-sink-mute $SINK toggle
fi
