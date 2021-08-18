#!/bin/sh
if [ $(xrandr | grep -w connected | wc -l) -eq 3 ]; then
    xrandr --output eDP1 --mode 2048x1152 --pos 0x1080 --rotate normal --output DP1 --off --output DP2 --mode 1920x1080 --pos 2048x0 --rotate left --output HDMI1 --primary --mode 1920x1080 --pos 128x0 --rotate normal --output VIRTUAL1 --off
else
    xrandr --output HDMI1 --auto --above eDP1
fi
