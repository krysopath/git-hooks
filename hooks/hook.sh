#!/bin/sh
#                       --<all your diff are belong to us>
#                       |
#                       |
#                       |
#               |       |
#               |      ---
#              ---     '-'
#              '-'  ____|_____
#           ____|__/    |    /
#          /    | /     |   /
#         /     |(      |  (
#        (      | \     |   \
#         \     |  \____|____\   /|
#         /\____|___`---.----` .' |
#     .-'/      |  \    |__.--'    \
#   .'/ (       |   \   |.          \
#_ /_/   \      |    \  | `.         \
# `-.'    \.--._|.---`  |   `-._______\
#    ``-.-------'-------'------------/
#        `'._______________________.'
#                 HMS HOOK

echo "$(
    tput bold
    tput setaf 1
)running $(basename "$0")"

for h in "$(dirname "$0")/$(basename "$0")".d/*; do
    if [ -x "$h" ]; then
        echo "$(
            tput bold
            tput setaf 2
        )running $h"
        $h || exit 1
    else
        echo "$h was marked with '-x' to not execute"
    fi
done
