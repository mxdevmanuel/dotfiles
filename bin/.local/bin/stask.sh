#!/usr/bin/env bash
FILE=$HOME/.lines/.lines

function delete_line(){
        sed -i -n "/$1/!p" $FILE
}
case "$1" in
        "add")
                message=$(dmenu -p "Add line" < /dev/null)
                if [[ -z "$(grep "$message" $FILE)" ]]
                then
                        echo $message >> $FILE
                fi
                ;;
        "view")
                selection=$(rofi -dmenu -p "🤔" < $FILE)
                if [[ $? -eq 10 ]]
                then
                        delete_line $selection
                fi
                ;;
        "delete")
                selection=$(rofi -dmenu -p "" < $FILE)
                delete_line $selection
                ;;

esac

        
