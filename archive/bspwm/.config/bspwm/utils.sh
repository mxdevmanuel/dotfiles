#!/usr/bin/env bash

function exec_once_or_signal(){
        if [ -z "$1" ];then
                return 1
        fi
        
        is_stopped=$(pgrep $1)
        if [ -z "$is_stopped" ]
        then
                echo "$1 starting"
                if [ $2 == 0 ]
                then
                        $1 $3 &
                else
                        $1 $3
                fi
        else
                echo "$1 running"
                if [ ! -z "$4" ]
                then
                        echo "signaling..."
                        pkill $4 $1
                fi
        fi
}

