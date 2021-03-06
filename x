#!/bin/sh

if [ "$(uname)" = "Linux" ]; then
    [ -n "$1" ] && sh -c "WM=$(which $1) startx" || sh -c "WM=$(which spectrwm) startx"
elif [ "$(uname)" = "OpenBSD" ]; then
    [ -n "$1" ] && sh -c "WM=$(which $1) startx" || sh -c "WM=$(which spectrwm) startx"
elif [ "$(uname)" = "FreeBSD" ]; then
    [ -n "$1" ] && sh -c "WM=$(which $1) startx" || sh -c "WM=$(which spectrwm) startx"
fi
