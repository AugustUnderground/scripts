#!/bin/sh

solid()
{
    hsetroot -solid "#5f819d"
}

wallpaper()
{
    [ -f "$HOME/Pictures/wp" ] && hsetroot -cover "$HOME/Pictures/wp" \
                               || solid
}

pacwall()
{
    PACWALL="$HOME/Pictures/pacwall.png"
    if [ -f $PACWALL ]; then
        NOW=$(date +%s)
        OLD=$(stat -c %Z $PACWALL)
        AGE=$(expr $NOW - $OLD)
        [ $AGE -lt 86400 ] && hsetroot -solid '#18161a' -full "$PACWALL" -flipv \
                           && exit 0
    fi

    if command -v xbpswall > /dev/null; then
        xbpswall -f twopi \
                 -b '#18161a' \
                 -x '#b294bb' \
                 -d '#5f819d' \
                 -o '#cc6666' \
                 -e '#c5c8c644' \
                 -p $PACWALL
    elif command -v pacwall > /dev/null ; then
        pacwall -b '#18161a' \
                -e '#b294bb' \
                -d '#5f819d' \
                -p '#cc6666' \
                -y '#8abeb7' \
                -u '#f0c674' \
                -f '#b5bd68' \
                -s '#c5c8c644' \
        mv "$HOME/pacwall.png" "$HOME/Pictures/"
    else
        solid
    fi
}

gradient()
{
    hsetroot -solid "#5f819d"
}

OPTIONS='swp'
while getopts $OPTIONS OPT; do
    case $OPT in
        s) solid ;;
        g) gradient ;;
        w) wallpaper ;;
        p) pacwall ;;
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

exit 0
