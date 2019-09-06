#!/bin/bash
POMOLOCK=1
WORK=1500
SHORTBREAK=300
LONGBREAK=900
CURRENT=1
FILE=/tmp/pomodoro.run 
DISPLAY=:0
WAIT=1

counter(){
       COUNTER=$2
       while sleep 1;do
               MIN=$(($COUNTER/60))
               SEC=$(($COUNTER%60))

               if [ -e "$FILE" ]
               then
                      printf "P [%02d:%02d]\n" $MIN $SEC
                       continue
               fi
               printf "%s [%02d:%02d]\n" $1 $MIN $SEC

               COUNTER=$(($COUNTER - 1))
               if [ $COUNTER == 0 ]
               then
                       break
               fi
       done
}

trap "touch $FILE" SIGUSR1
trap "rm $FILE" SIGUSR2

while sleep 1;do
        if [ -e "$FILE" ]
        then
                echo "? [--:--]"
                continue
        fi

        case $CURRENT in
                1|3|5|7)
                        notify-send Pomodoro "It's time to work" -t 5000 -i ~/.pomo/icon.png 
                        counter "W" $WORK
                        CURRENT=$(($CURRENT + 1))
                        ;;
                2|4|6)
                        [ ! -z "$POMOLOCK" ] && betterlockscreen -l -t "take a short break" & 
                        [ -z "$POMOLOCK" ] && notify-send Pomodoro "time to take a short break" -t 5000 -i ~/.pomo/icon.png 
                        counter "B" $SHORTBREAK
                        [ ! -z "$POMOLOCK" ] && pkill i3lock
                        CURRENT=$(($CURRENT + 1))
                        ;;
                8)
                        [ ! -z "$POMOLOCK" ] && betterlockscreen -l -t "time for a longer break" & 
                        [ -z "$POMOLOCK" ] && notify-send Pomodoro "time to take a longer break" -t 5000 -i ~/.pomo/icon.png 
                        counter "LB" $LONGBREAK
                        [ ! -z "$POMOLOCK" ] && pkill i3lock
                        CURRENT=1
        esac
        echo "again..."
done

