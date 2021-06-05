#!/bin/sh

BAR="    " #"▂▄▆█"
SIG="0"
getWifiState()
{
    SIG="$(nmcli dev wifi | awk '{if($1=="*" && $2!="SSID")print $8;}')"
    BAR="$(nmcli dev wifi | awk '{if($1=="*" && $2!="SSID")print $9;}')"

    if [ -z "$SIG" ]; then
        CON=""
    elif [ "$SIG" -le 25 ]; then
        CON=""
    elif [ "$SIG" -le 50 ]; then
        CON=""
    elif [ "$SIG" -le 75 ]; then
        CON=""
    else
        CON=""
    fi

}

VOL="0%"
getVolume()
{
    #VOL=$(amixer sget Master | grep -oP '\d+\%' | sed -Ee 's/%//g' | head -n 1) 
    VOL="$(pulsemixer --get-volume | cut -d' ' -f 1)"
    
    if [ "$VOL" -le 0 ]; then
        SPEAKER=""
    elif [ "$VOL" -le 50 ]; then
        SPEAKER=""
    else
        SPEAKER=""
    fi
}

CAP="0"
STAT="?"
AC="?"
NOTIF_FULL=false
HED_NOTF="Battery Status"
LOW_NOTF="Battery really low (< 15%), plug me in\!"
FUL_NOTF="Battery fully charged, you can unplug me now."
BEEP='( speaker-test -t sine -f 1300 &> /dev/null)& pid=$!; sleep 0.3s; kill -9 $pid >/dev/null 2>&1'
getBattery()
{
    CAP="$(cat /sys/class/power_supply/*/capacity | head -n 1)"
    STAT="$(cat /sys/class/power_supply/*/status)"
    if [ "$STAT" = "Charging" ]; then
        BAT_STAT=""
    elif [ "$STAT" = "Discharging" ];then
        if [ "$CAP" -le 15 ]; then
            BAT_STAT=" "
        elif [ "$CAP" -le 25 ]; then
            BAT_STAT=" "
        elif [ "$CAP" -le 50 ]; then
            BAT_STAT=" "
        elif [ "$CAP" -le 75 ]; then
            BAT_STAT=" "
        else
            BAT_STAT=" "
        fi
    else
        BAT_STAT=""
    fi

    if [ "$CAP" -le 15 ] && [ "$STAT" != "Charging" ]; then
        NOTIF_FULL=false
        eval "$BEEP"
        notify-send "$HED_NOTF" "$LOW_NOTF" --icon=battery
    elif [ "$CAP" -gt 99 ] && [ "$STAT" = "Full" ] && [ ! NOTIF_FULL ]; then
        notify-send "$HED_NOTF" "$FUL_NOTF" --icon=battery
        NOTIF_FULL=true
    fi
}

while true; do
    getWifiState
    getVolume
    getBattery

    DATE=" $(date +"%Y-%m-%d")"
    TIME=" $(date +"%H:%M")"
    DATE_TIME=""
    WIFI="$CON $SIG%"
    BAT="$BAT_STAT $CAP%"
    SOUND="$SPEAKER $VOL%"
    STATUS="$WIFI $SOUND $BAT $DATE $TIME  "

    xsetroot -name "$STATUS"
    
    sleep 1
done

