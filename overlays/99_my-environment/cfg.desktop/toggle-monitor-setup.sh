#!/usr/bin/env sh

set -e

lvdsEnable=${1:-enable}

if swaymsg -p -t get_outputs | grep -q "^Output DP-1"
then
    swaymsg output LVDS-1 $lvdsEnable
    swaymsg output DP-1 enable
    swaymsg output LVDS-1 position 0 672
    swaymsg output DP-1   position 1366 0
else
    swaymsg output LVDS-1 enable
    swaymsg output DP-1 disable
    swaymsg output LVDS-1 position 0 0
fi

