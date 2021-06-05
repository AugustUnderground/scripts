#!/bin/sh

[ $(command -v maim) ] && CMD=maim || CMD=scrot
NAME="$HOME/Pictures/screengrab-$(date +%Y-%m-%d-%H%M%S).png"
$CMD | tee $NAME | xclip -selection clipboard -t image/png
