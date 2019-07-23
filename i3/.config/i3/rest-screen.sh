export DISPLAY=:0
xdotool key "ctrl+super+l"
echo "Start count"
sleep 5m
notify-send -i ~/.pomo/icon.png -a Pomo "Its time to go back to work"
aplay ~/.config/i3/bells.wav
