#!/bin/sh

[ -n "$1" ] && sh -c "WM=$(which $1) startx" || sh -c "WM=$(which spectrwm) startx"
