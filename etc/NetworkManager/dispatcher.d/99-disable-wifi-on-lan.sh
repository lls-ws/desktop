#!/bin/bash

INTERFACE=$1
ACTION=$2

if [ "$INTERFACE" = "enp8s0" ]; then
    case "$ACTION" in
        up)
            nmcli radio wifi off
            ;;
        down)
            nmcli radio wifi on
            ;;
    esac
fi
