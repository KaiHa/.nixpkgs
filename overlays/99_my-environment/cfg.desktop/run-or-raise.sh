#!/usr/bin/env sh

set -e

cmd=${1:?}
class=${2:?}

if swaymsg -t get_tree | grep -q "\"class\": \"$class\""; then
    swaymsg "[class=\"$class\"] focus"
else
    swaymsg -- exec $cmd
fi

