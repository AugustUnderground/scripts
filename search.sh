#!/bin/sh

SEARCH_CMD="$1"
INSTALL_CMD="$2"
PREFIX="$3"
SUFFIX="$4"
INSTALLED="$5"
QUERY="$6"

RESULTS="$($SEARCH_CMD "$QUERY")"
[ -z "$RESULTS" ] && printf "Query $QUERY returned no results.\n" && exit 1

PKG="$(printf "$RESULTS" | fzf)"
[ -z "$PKG" ] && printf "No package selected.\n" && exit 2
[ "${PKG#*$INSTALLED}" != "$PKG" ] && printf "Package already installed.\n" && exit 0

PKG=${PKG##$PREFIX}
PKG=${PKG%%$SUFFIX}

sudo $INSTALL_CMD $PKG
