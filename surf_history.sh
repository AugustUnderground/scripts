#!/bin/sh
tac ~/.surf/history | dmenu -nb '#18161a' -nf '#c5c8c6' -sb '#282a2e' -sf '#8abeb7' -nhb '#18161a' -nhf '#85678f' -shb '#282a2e' -shf '#5f819d' -bw 2 -h 25 -x 140 -y 50 -w 1000 -p "History:" -l 7
