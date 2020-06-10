#!/bin/bash
POMOLOCK=1
WORK=1500
SHORTBREAK=300
LONGBREAK=900
IDLETHRESH=310000 # miliseconds
CURRENT=1
FILE=/tmp/pomodoro.run 
DISPLAY=:0
WAIT=1
LEVER=0

notify(){
        case $1 in
                "W")
                notify-send Pomodoro "time to take a break in 10s" -t 5000 -i ~/.pomo/icon.png 
                ;;
        esac
}

counter(){
       COUNTER=$2
       while sleep 1;do
               if [[ $LEVER == 1 ]]
               then
                       LEVER=0
                       break
               fi

               MIN=$(($COUNTER/60))
               SEC=$(($COUNTER%60))

               if [ -e "$FILE" ]
               then
                      printf "P [%02d:%02d]\n" $MIN $SEC
                       continue
               fi
               printf "%s [%02d:%02d]\n" $1 $MIN $SEC

               COUNTER=$(($COUNTER - 1))
               if [ $COUNTER == 10 ]
               then
                       notify $1
               fi

               if [ $COUNTER == 0 ]
               then
                       break
               fi
       done
}

select-mode(){
        SELECTION=$(echo -e "work\nbreak\nrest\ntoggle\npause\nresume\nrestart\nadvance" | dmenu -p timer)
        case $SELECTION in
                "work")
                        if [[ $CURRENT == 1 ]] || [[ $CURRENT == 3 ]] || [[ $CURRENT == 5 ]] || [[ $CURRENT == 7 ]]
                        then
                                break
                        elif [[ $CURRENT == 8 ]]
                        then
                                CURRENT=0
                                LEVER=1
                        else
                                LEVER=1
                        fi
                        ;;
                "break")
                        if [[ $CURRENT == 2 ]] || [[ $CURRENT == 4 ]] || [[ $CURRENT == 6 ]]
                        then
                                break
                        else
                                LEVER=1
                        fi
                        ;;
                "rest")
                        if [[ $CURRENT == 8 ]]
                        then
                                break
                        else
                                CURRENT=7
                                LEVER=1
                        fi
                        ;;
                "toggle" | "resume" | "pause")
                        notify-send Pomodoro "${SELECTION^} timer" -t 5000 -i ~/.pomo/icon.png 
                        toggle-timer
                        ;;
                "restart")
                        notify-send Pomodoro "Restarted timer" -t 5000 -i ~/.pomo/icon.png 
                        CURRENT=$(($CURRENT - 1))
                        LEVER=1
                        ;;
                "advance")
                        notify-send Pomodoro "Advanced timer" -t 5000 -i ~/.pomo/icon.png 
                        LEVER=1
                        ;;
        esac
}


toggle-timer() {
        if [[ -f $FILE ]]
        then
                rm $FILE
        else
                touch $FILE
        fi
}

trap "select-mode" SIGUSR1
trap "toggle-timer" SIGUSR2

while sleep 1;do
        if [ -e "$FILE" ]
        then
                echo "? [--:--]"
                continue
        fi

        case $CURRENT in
                1)
                        notify-send Pomodoro "Let's start to work" -t 5000 -i ~/.pomo/icon.png 
                        counter "W" $WORK
                        CURRENT=$(($CURRENT + 1))
                        ;;
                3|5|7)
                        if [ -z "$ISIDLE" ]
                        then
                                # Beep computer speaker
                                echo -ne '\007'
                                # Play wav sound
                                cvlc ~/.local/share/sounds/bell.mp3 --play-and-exit > /dev/null 2>&1
                        fi

                        IDLE=$(xprintidle)
                        if [ $IDLE -gt $IDLETHRESH ]
                        then
                                sleep 2
                                echo "I [--:--]"
                                ISIDLE=1
                                continue
                        fi

                        if [ ! -z "$ISIDLE" ]
                        then  
                                unset ISIDLE
                        fi

                        notify-send Pomodoro "It's time to work" -t 5000 -i ~/.pomo/icon.png 
                        counter "W" $WORK
                        CURRENT=$(($CURRENT + 1))
                        ;;
                2|4|6)
                        [ ! -z "$POMOLOCK" ] && lock.sh --greetertext="Take a break" --greetercolor="#ebdbb2" &
                        counter "B" $SHORTBREAK
                        [ ! -z "$POMOLOCK" ] && pkill i3lock
                        CURRENT=$(($CURRENT + 1))
                        ;;
                8)
                        [ ! -z "$POMOLOCK" ] && lock.sh --greetertext="Rest for a while" --greetercolor="#ebdbb2" &
                        counter "LB" $LONGBREAK
                        [ ! -z "$POMOLOCK" ] && pkill i3lock
                        CURRENT=1
        esac
        echo "again..."
done

