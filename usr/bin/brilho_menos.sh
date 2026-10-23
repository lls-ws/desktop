#!/bin/bash
xrandr --output LVDS-1 --brightness $(echo $(xrandr --verbose | grep -m 1 -i brightness | cut -d ' ' -f 2) - 0.1 | bc)
