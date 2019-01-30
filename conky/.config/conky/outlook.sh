#!/bin/bash
FETCH=$(fetchmail --check)
TOTAL=$(echo "${FETCH}" | cut -d" " -f1)
READ=$(echo "${FETCH}" | cut -d" " -f3 | sed 's/(//')
echo $(echo "$TOTAL - $READ" | bc)
