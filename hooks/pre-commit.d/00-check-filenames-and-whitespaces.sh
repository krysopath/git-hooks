#!/bin/bash
if git rev-parse --verify HEAD >/dev/null 2>&1; then
    against=HEAD
else
    # Initial commit: diff against an empty tree object
    against=$(git hash-object -t tree /dev/null)
fi

# If you want to allow non-ASCII filenames set this variable to true.
allownonascii="$(git config --bool hooks.allownonascii)"

# Redirect output to stderr.
exec 1>&2

if [ "$allownonascii" != "true" ] &&
    test $(git diff --cached --name-only --diff-filter=A -z "$against" |
        LC_ALL=C tr -d '[ -~]\0' | wc -c) != 0; then
    cat <<\EOF
Error: Attempt to add a non-ASCII file name.

This can cause problems if you want to work with people on other platforms.
To be portable it is advisable to rename the file. If you know what you are
doing you can disable this check using:

  git config hooks.allownonascii true
EOF
    exit 1
fi

# If there are whitespace errors, print the offending file names and fail.
# shellcheck disable=SC2093
exec git diff-index --check --cached "$against" --
