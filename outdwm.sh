#!/bin/sh

OPTIONS="Disable\nDuplicate\nExtend\nDock"
MODE=$(echo "$OPTIONS" | dmenu -nb '#2E3440' \
                               -nf '#D8DEE9' \
                               -sb '#4C566A' \
                               -sf '#ECEFF4' \
                               -nhb '#2E3440'\
                               -nhf '#5E81AC'\
                               -shb '#4C566A'\
                               -shf '#88C0D0'\
                               -fn "FantasqueSansMono Nerd Font:size=15" \
                               -bw 2 \
                               -l 5 \
                               -h 25 \
                               -x 390 \
                               -y 150 \
                               -w 600 \
                               -i -p  "Select Output:")

MAIN_RES="$(xrandr | grep -w connected | awk -F'[ +]' '{print $4}' | sed '1q;d')"
EXT_RES="$(xrandr | grep -w connected | awk -F'[ +]' '{print $3}' | sed '2q;d')"

DISPLAYS="$(xrandr | grep -w connected | awk '{print $1}')"
MAIN_DISP=$(echo $DISPLAYS | cut -d " " -f1)
EXT_DISP=$(echo $DISPLAYS | cut -d " " -f2)

MAIN_HEIGHT=$(echo $MAIN_RES | sed 's/.*x//g')
EXT_HEIGHT=$(echo $EXT_RES | sed 's/.*x//g')
XOFFSET=$(echo $MAIN_RES | sed 's/x.*//g')
YOFFSET=$(expr $EXT_HEIGHT - $MAIN_HEIGHT)
YOFFSET=$(expr $YOFFSET / 2)

if [ "$MODE" = "Laptop" ]; then
    xrandr --output $DISPLAYS --off
    xrandr --output $MAIN_DISP --auto
elif [ "$MODE" = "Duplicate" ]; then
    xrandr --output $EXT_DISP --off
    xrandr --output $EXT_DISP --auto
    xrandr --output $EXT_DISP --same-as $MAIN_RES
    $HOME/dotfiles/scripts/setwp.sh -s
elif [ "$MODE" = "Extend" ]; then
    xrandr --output $EXT_DISP --off
    xrandr --output $EXT_DISP --auto --right-of $MAIN_DISP
    xrandr --output $MAIN_DISP --auto --pos 0x$YOFFSET
    $HOME/dotfiles/scripts/setwp.sh -s
elif [ "$MODE" = "Dock" ]; then
    EXT_DISPS=$(xrandr | grep -w connected | awk '{print $1}' | tail -n +2)
    xrandr --output DP2-1 --off
    xrandr --output DP2-2 --off
    xrandr --output DP2-2 --auto --right-of $MAIN_DISP
    xrandr --output DP2-1 --auto --right-of DP2-2
    xrandr --output $MAIN_DISP --auto --pos 0x$YOFFSET
    $HOME/dotfiles/scripts/setwp.sh -s
fi

