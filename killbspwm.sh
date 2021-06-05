#!/bin/sh

[ "$(printf "No\nYes" | \
    dmenu -nb darkred -nf gray -sb red -sf white \
          -fn "Monofur Nerd Font:pixelsize=15:autohint=true:style=Book" \
          -bw 2 -h 25 -w 450 -x 50 -y 50 \
          -i -p "Close BSPWM and Kill X Session?")" = "Yes" ] && bspc quit
