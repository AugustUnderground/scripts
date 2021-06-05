#!/bin/bash

BG_COLOR='#18161a'
ENODE_COLOR='#b294bb'
DNODE_COLOR='#5f819d'
ONODE_COLOR='#cc6666'
EDGE_COLOR='#c5c8c644'
RANKSEP=0.7
ROOT="xbps"
ROTATE=0

DOT_CMD="twopi"

DOT_FILE="/tmp/xbps.gv"
PNG_FILE="$HOME/Pictures/pacwall.png"

IMAGE_ONLY=false

SCREEN_SIZE=$(xrandr | grep \* | sed -E -e 's/^\s*//g' -e 's/\s+.*$//g')
#$(xrandr | grep \* | awk '{print $1}')

main ()
{
    echo "strict digraph G {" > $DOT_FILE

    EPKGS=$(xbps-query -m | tr '\n' ' ')

    for PKG in $EPKGS; do
        echo "\"$PKG\" [color=\"$ENODE_COLOR\"]" >> $DOT_FILE
        DPKGS=$(xbps-query -x $PKG | sed -E -e 's/>?=.*//g' | tr '\n' ' ')
        for DEP in $DPKGS; do
            echo "\"$DEP\" [color=\"$DNODE_COLOR\"]" >> $DOT_FILE
            echo "\"$PKG\" -> \"$DEP\";" >> $DOT_FILE
        done
    done

    OPKGS=$(xbps-query -O | tr '\n' ' ')
    for ORPH in $OPKGS; do
        echo "\"$ORPH\" [color=\"$ONODE_COLOR\"]" >> $DOT_FILE
        ODPKGS=$(xbps-query -x $ORPH | sed -E -e 's/>?=.*//g' | tr '\n' ' ')
        for ODEP in $ODPKGS; do
            echo "\"$ODEP\" [color=\"$DNODE_COLOR\"]" >> $DOT_FILE
            echo "\"$ORPH\" -> \"$ODEP\";" >> $DOT_FILE
        done
    done

    echo "}" >> $DOT_FILE

    $DOT_CMD -Tpng \
             -Gbgcolor='#00000000' \
             -Granksep=$RANKSEP \
             -Groot=$ROOT \
             -Grotate=$ROTATE \
             -Ecolor=$EDGE_COLOR \
             -Ncolor=$NODE_COLOR \
             -Nheight=0.1 \
             -Nwidth=0.1 \
             -Nshape=point \
             -Earrowhead=normal \
             $DOT_FILE > $PNG_FILE
             #-Goverlap=false \
    
    [ "$IMAGE_ONLY" = false ] && \
        hsetroot -solid $BG_COLOR -full $PNG_FILE -flipv 1>& /dev/null
        #feh --image-bg $BG_COLOR --bg-max $PNG_FILE
}

help() {
    echo "USAGE: $0
        [ -i ]
        [ -f DOT_FILTER ]
        [ -b BACKGROUND_COLOR ]
        [ -x EXPLICIT_NODE_COLOR ]
        [ -d DEPENDENCY_NODE_COLOR ]
        [ -o ORPHAN_NODE_COLOR ]
        [ -e EDGE_COLOR ]
        [ -s RANKSEP ]
        [ -c CENTER ]
        [ -r ROTATE ]
        [ -p OUTPUT_PNG ]

        Use -i to suppress wallpaper setting.

        All colors may be specified either as
        - a color name (black, darkorange, ...)
        - a value of format #RRGGBB
        - a value of format #RRGGBBAA

        DOT_FILTER can be any filter defined in DOT(1). 
            Default is **twopi**.
        RANKSEP is the distance in between the concentric circles.
        CENTER is the name of the package in at the root of the graph.
        ROTATE is the angle at which the output is rotated.
        OUTPUT is the path of the generated image."

    exit 0
}

OPTIONS='if:b:x:d:o:e:s:c:r:p:h'
while getopts $OPTIONS OPT; do
    case $OPT in
        i) IMAGE_ONLY=true ;;
        f) DOT_CMD=${OPTARG} ;;
        b) BG_COLOR=${OPTARG} ;;
        x) ENODE_COLOR=${OPTARG} ;;
        d) DNODE_COLOR=${OPTARG} ;;
        o) ONODE_COLOR=${OPTARG} ;;
        e) EDGE_COLOR=${OPTARG} ;;
        s) RANKSEP=${OPTARG} ;;
        c) ROOT=${OPTARG} ;;
        r) ROTATE=${OPTARG} ;;
        p) PNG_FILE=${OPTARG} ;;
        h) help ;;
        \?)
            echo "Unknown option: -${OPTARG}" >&2
            exit 1
            ;;
        :)
            echo "Missing option argument for -${OPTARG}" >&2
            exit 1
            ;;
        *)
            echo "Unimplemented option: -${OPTARG}" >&2
            exit 1
            ;;
    esac
done
shift $((OPTIND - 1))

main "$@"
