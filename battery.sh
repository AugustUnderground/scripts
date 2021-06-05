#!/bin/bash

BATTERY='/sys/class/power_supply/BAT0'

HED_NOTF="Battery Status"
LOW_NOTF="Battery really low ($CAPACITY %), plug me in\!"
FUL_NOTF="Battery fully charged, you can unplug me now."

BEEP='( speaker-test -t sine -f 1300 &> /dev/null)& pid=$!; sleep 0.3s; kill -9 $pid >/dev/null 2>&1'


while true; do
    CAPACITY=$(<$BATTERY/capacity)
    STATUS=$(<$BATTERY/status)
    if [ $CAPACITY -lt 12 ] && [ $STATUS != 'Charging' ]; then
        eval "$BEEP"
        notify-send "$HED_NOTF" "$LOW_NOTF" --icon=battery
    elif [ $CAPACITY -gt 99 ] && [ $STATUS = 'Full' ]; then
        notify-send "$HED_NOTF" "$FUL_NOTF" --icon=battery
    fi
    sleep 60
done
