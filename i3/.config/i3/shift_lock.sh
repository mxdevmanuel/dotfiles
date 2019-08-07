#!/bin/bash

SHIFTLOCK="/tmp/shiftlock"

if [ -f "$SHIFTLOCK" ]
then
	pkill dzen2
	rm "$SHIFTLOCK"
else
	touch "$SHIFTLOCK"
	echo "Shift Lock" | dzen2 -bg "#ff00ff"  -fg "#000000" -w 1366 -e "MAnuel" -ta c -p -1
fi

