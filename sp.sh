#!/bin/sh

CWD_LONG=$(dirname $1 | sed "s|$HOME|~|g")
MAX_PATH_LEN=$2

# Get final path segment 
FINAL_DIR=$(basename $1)
FINAL_DIR_LEN=${#FINAL_DIR}

# If the last directory is >= the maximum length
if [ "$FINAL_DIR_LEN" -ge "$MAX_PATH_LEN" ]; then
    echo ".../$FINAL_DIR"
    exit 0
elif [ "$1" = "$HOME" ]; then
    echo "~"
    exit 0
fi

# Get all preceeding directories in a space separated list
LIST_DIRS=$(echo $CWD_LONG | tr '/' ' ')

# Count the number of preceeding directories
NUM_DIRS=$(echo "$LIST_DIRS" | wc -w)

# Subtract length of final directory + / from max length
MAX_DIR_LEN=$(( ((MAX_PATH_LEN - FINAL_DIR_LEN - 1) / NUM_DIRS) - 1))

# If there are too many directories to fit in max length
if [ "$MAX_DIR_LEN" -lt 1 ]; then
    MAX_DIR_LEN=1
    NUM_DIRS=$(( ((MAX_PATH_LEN - FINAL_DIR_LEN) / 2) - 4 ))
    LIST_DIRS=$(echo $LIST_DIRS | tr ' ' '\n' | tail -n $NUM_DIRS | tr '\n' ' ')
    SHORT_PATH=".../"
fi

# Initialize resulting short path
# If the path is not under home, preceede with /
[ ${CWD_LONG%"${CWD_LONG#?}"} != "~" ] && SHORT_PATH="/$SHORT_PATH"

for DIR in $LIST_DIRS; do
    LENGTH=$(yes "?" | head -n $MAX_DIR_LEN | tr '\n' ':' | sed 's/://g')
    [ ${#DIR} -le $MAX_DIR_LEN ] && SHORT_DIR=$DIR\
                                 || SHORT_DIR=${DIR%"${DIR#${LENGTH}}"}
    SHORT_PATH="$SHORT_PATH$SHORT_DIR/"
done
SHORT_PATH="$SHORT_PATH$FINAL_DIR"

echo ${#SHORT_PATH}
echo $SHORT_PATH
exit 0
