#!/usr/bin/env sh

set -e

if [ -n "${1}" ]
then
    lvdsEnable=${1}
elif grep -q closed /proc/acpi/button/lid/LID/state
then
    lvdsEnable=disable
else
    lvdsEnable=enable
fi

if swaymsg -p -t get_outputs | grep -q "^Output DP-1"
then
    swaymsg output LVDS-1 $lvdsEnable
    swaymsg output LVDS-1 position 0 672
    swaymsg output DP-1   position 1366 0
    swaymsg output DP-1 dpms on
else
    swaymsg output LVDS-1 enable
    swaymsg output DP-1 disable
    swaymsg output LVDS-1 position 0 0
fi

