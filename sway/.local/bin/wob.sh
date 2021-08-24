#!/usr/bin/env bash

WOBSOCK=/tmp/wob.sock

pkill wob

if [[ ! -p $WOBSOCK ]]
then
	if [[ -f $WOBSOCK ]]
	then
		rm $WOBSOCK
	fi
        mkfifo $WOBSOCK
fi

tail -f $WOBSOCK | wob &

echo "first"
