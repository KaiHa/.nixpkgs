#!/usr/bin/env sh

set -e

cmd=${1:?}
id=${2:?}

if swaymsg -t get_tree | grep -q "\"class\": \"${id}\""; then
    swaymsg "[class=\"${id}\"] focus"
elif swaymsg -t get_tree | grep -q "\"app_id\": \"${id}\""; then
    swaymsg "[app_id=\"${id}\"] focus"
else
    swaymsg -- exec $cmd
fi

