#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Usage: $0 [options] search_string filename"
    exit 1
fi

opts=""
if [[ $1 == -* ]]; then
    opts=$1
    shift
fi

search="$1"
file="$2"

if [ ! -f "$file" ]; then
    echo "Error: File not found."
    exit 1
fi

n_flag=false
v_flag=false

if [[ $opts == *n* ]]; then
    n_flag=true
fi
if [[ $opts == *v* ]]; then
    v_flag=true
fi

line=0
while IFS= read -r l; do
    line=$((line+1))
    if echo "$l" | grep -iq "$search"; then
        found=true
    else
        found=false
    fi

    if $v_flag; then
        found=$( [ "$found" = false ] && echo true || echo false )
    fi

    if [ "$found" = true ]; then
        if $n_flag; then
            echo "$line:$l"
        else
            echo "$l"
        fi
    fi
done < "$file"
