#!/bin/bash
STAGED=$(git diff --staged --name-only)
HEAVY_FILES=""

check_fat() {
    if grep "$1" <<< "$2" &>/dev/null
    then
        echo -e "$(
            tput bold
            tput setaf 1
        )FOUND: huge ass file:\n$1"
        export HEAVY_FILES=$HEAVY_FILES:$1
		fi
}


if [ ! -z "$STAGED" ]; then
    FOUND="$(find . -not -path "./.git*" -type f -size +1M)"
    for staged in ${STAGED[*]}
    do
        check_fat "$staged" "$FOUND"
    done

    if [ ! -z "$HEAVY_FILES"  ]
    then
        exit 1
    fi
fi
