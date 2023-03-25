#!/bin/sh
# Script to start a terminal with defined colors
#
# email: lls.homeoffice@gmail.com

CMD_TERM="xterm -fn 10x20 -bg black -fg"

if [ -z "$1" ]; then

	COLOR="#FF0000"

	${CMD_TERM} ${COLOR} &

else
	
	COLOR="#43D216"
	
	sudo ${CMD_TERM} ${COLOR} &

fi
