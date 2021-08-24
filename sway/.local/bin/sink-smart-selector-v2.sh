#!/usr/bin/env bash
SINK=$(pactl list short sinks | grep RUNNING | gawk '{print $1}') 
WOBSOCK=/tmp/wob.sock

function report(){
	pulsemixer --get-volume | sed 's/\s[0-9]\{1,2\}/ #282828ff #7c6f64ff #8ec07cff/' > $WOBSOCK
}

if [ -z "$SINK" ]
then
	SINK=$(pactl get-default-sink)
fi

if [ "$1" != "mute" ]
then
        pactl set-sink-volume $SINK $1
	report
else
        pactl set-sink-mute $SINK toggle
	v="`pactl get-sink-mute $SINK`"
	if [[ $v =~ "no" ]]
	then
		# icon=$ICON_DIR/48x48/status/notification-audio-volume-high.svg
		report
	else
		# icon=$ICON_DIR/48x48/status/notification-audio-volume-muted.svg
		echo "100 #282828ff #7c6f64ff #fb4934ff" > $WOBSOCK
	fi

	# notify-send -t 500 -i $icon $v
fi

