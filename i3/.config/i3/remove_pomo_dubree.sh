#!/bin/bash
if [ -S ~/.pomo/pomo.sock ] || [ -S ~/.pomo/pomo.sock= ]
then
	rm ~/.pomo/pomo.sock*
fi

