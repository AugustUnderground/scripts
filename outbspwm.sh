#!/bin/bash

OPTIONS="Laptop\nBeamer\nDesk\nMirror\n"
SELECT=$(echo -e $OPTIONS | dmenu -nb '#18161a' \
                                  -nf '#c5c8c6' \
                                  -sb '#282a2e' \
                                  -sf '#8abeb7' \
                                  -nhb '#85678f'\
                                  -nhf '#8abeb7'\
                                  -shb '#5f819d'\
                                  -shf '#18161a'\
                                  -bw 2 \
                                  -l 1 \
                                  -h 25 \
                                  -x 390 \
                                  -y 150 \
                                  -w 500 \
                                  -i -p "Select Output:")

if [[ $SELECT == "Beamer" ]]; then
    xrandr --output LVDS1 --output VGA1 --right-of LVDS1
    feh --bg-fill ~/Pictures/wp
    bspc monitor LVDS1 -d ᚠ ᚢ ᚦ ᚨ ᚱ 
    bspc monitor VGA1 -d ᚲ ᛉ ᛊ ᛏ ᛟ
    polybar -r local &
    polybar -r beamer &
elif [[ $SELECT == "Desk" ]]; then
    xrandr --output LVDS1 --output VGA1 --right-of LVDS1
    xrandr --output VGA1 --mode 1920x1200
    feh --bg-fill ~/Pictures/wp
    bspc monitor LVDS1 -d ᚠ ᚢ ᚦ ᚨ ᚱ 
    bspc monitor VGA1 -d ᚲ ᛉ ᛊ ᛏ ᛟ
    polybar -r local &
    polybar -r desk &
elif [[ $SELECT == "Mirror" ]]; then
    xrandr --output LVDS1 --output VGA1 --same-as LVDS1
    feh --bg-fill ~/Pictures/wp
    bspc monitor LVDS1 -d ᚠ ᚢ ᚦ ᚨ ᚱ ᚲ ᛉ ᛊ ᛏ ᛟ
    polybar -r main &
elif [[ $SELECT == "Laptop" ]]; then
    #xrandr --output VGA --auto
    feh --bg-fill ~/Pictures/wp
    bspc monitor LVDS1 -d ᚠ ᚢ ᚦ ᚨ ᚱ ᚲ ᛉ ᛊ ᛏ ᛟ
    polybar -r main &
else
    #xrandr --output VGA --auto
    feh --bg-fill ~/Pictures/wp
    bspc monitor LVDS1 -d ᚠ ᚢ ᚦ ᚨ ᚱ ᚲ ᛉ ᛊ ᛏ ᛟ
    polybar -r main &
fi
