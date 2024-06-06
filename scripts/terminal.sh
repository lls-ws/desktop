#!/bin/sh
# Script to start a terminal with defined colors
#
# email: lls.homeoffice@gmail.com

CMD_XTERM="xterm -fn 10x20 -bg black -fg"

CMD_GTERM="qterminal"
#CMD_GTERM="gnome-terminal --tab"

if [ -z "$1" ]; then

	COLOR="#FF0000"

	${CMD_XTERM} ${COLOR} &

else
	
	${CMD_GTERM} &

fi
