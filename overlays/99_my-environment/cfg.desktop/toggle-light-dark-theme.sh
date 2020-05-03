#!/usr/bin/env bash

set -e

cfg=~/.config/alacritty/alacritty.yml
dark=~/.config/alacritty/alacritty-dark.yml
light=~/.config/alacritty/alacritty-light.yml

if cmp ${cfg} ${light}
then
    cat ${dark} > ${cfg}
    emacsclient --eval "(kai/theme-toggle 'dark)"
    gawk -i inplace '/gtk-application-prefer-dark-theme/ { print "gtk-application-prefer-dark-theme = true"; next }; { print }' ~/.config/gtk-3.0/settings.ini
else
    cat ${light} > ${cfg}
    emacsclient --eval "(kai/theme-toggle 'light)"
    gawk -i inplace '/gtk-application-prefer-dark-theme/ { print "gtk-application-prefer-dark-theme = false"; next }; { print }' ~/.config/gtk-3.0/settings.ini
fi
