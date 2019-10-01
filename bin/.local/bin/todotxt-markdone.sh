#!/usr/bin/env bash
TODOFILE="/home/$USER/Todo/todo.txt"
ORIGINAL=$(cat)
#echo "Original $ORIGINAL"
PRIORITY=$(echo $ORIGINAL | grep -o "([A-Z])" | tr -d "()")
#echo "PRIORITY $PRIORITY"
DONE=$(echo $ORIGINAL | sed 's/([A-Z])/x/' | tr -d '\n')
#echo "DONE $DONE"
#echo "$DONE pri:$PRIORITY"
sed "s/$ORIGINAL/$DONE pri:$PRIORITY/" -i $TODOFILE
