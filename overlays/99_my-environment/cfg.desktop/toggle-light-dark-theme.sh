#!/usr/bin/env bash

set -e

cfg=~/.config/alacritty/alacritty.yml
dark=~/.config/alacritty/alacritty-dark.yml
light=~/.config/alacritty/alacritty-light.yml

if [[ $(awk '/gtk-application-prefer-dark-theme/ { print $3 }' ~/.config/gtk-3.0/settings.ini) = false ]]
then
    cat ${dark} > ${cfg}
    emacsclient --eval "(kai/theme-toggle 'dark)" && true
    gawk -i inplace '/gtk-application-prefer-dark-theme/ { print "gtk-application-prefer-dark-theme = true"; next }; { print }' ~/.config/gtk-3.0/settings.ini
    gawk -i inplace '/gtk-application-prefer-dark-theme/ { print "gtk-application-prefer-dark-theme = true"; next }; { print }' ~/.config/gtk-4.0/settings.ini
else
    cat ${light} > ${cfg}
    emacsclient --eval "(kai/theme-toggle 'light)" && true
    gawk -i inplace '/gtk-application-prefer-dark-theme/ { print "gtk-application-prefer-dark-theme = false"; next }; { print }' ~/.config/gtk-3.0/settings.ini
    gawk -i inplace '/gtk-application-prefer-dark-theme/ { print "gtk-application-prefer-dark-theme = false"; next }; { print }' ~/.config/gtk-4.0/settings.ini
fi
