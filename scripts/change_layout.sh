#!/bin/sh

CURRENT_LAYOUT=$(xkblayout-state print %s)

if [ $CURRENT_LAYOUT == "lt" ]; then
    setxkbmap us
else
    setxkbmap lt
fi

pkill -SIGRTMIN+9 i3blocks
