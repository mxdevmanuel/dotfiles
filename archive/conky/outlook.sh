#!/bin/bash
FETCH=$(fetchmail --check)
TOTAL=$(echo "${FETCH}" | cut -d" " -f1)
READ=$(echo "${FETCH}" | cut -d" " -f3 | sed 's/(//')

if [[ $READ =~ '^[0-9]+$' ]]
then
	echo $(echo "$TOTAL - $READ" | bc)
else
	echo $TOTAL
fi
