#!/bin/bash
STAGED="$(git diff --staged --name-only)"
CHANGED="$(grep '^.*\.sh' <<<"$STAGED" || [[ $? == 1 ]])"
LINT_SHELL=bash

SHFMT_FORCE=true
SHFMT="$(which shfmt)"
SHFMT_ARGS="-ln $LINT_SHELL -ci -bn -i 4 -w"

if [ ! -z "$SHFMT" ]; then
    if [ ! -e "$CHANGED" ]; then
        # run shfmt with args
        "$SHFMT" $SHFMT_ARGS $CHANGED
        # Stage updated/shfmt'ed files
        git add -u
    fi
else
    echo "$(tput setaf 4)WARN: $0: no shfmt found in PATH: $PATH"
    echo -e "Run\n\tGO111MODULE=on go get github.com/mvdan/sh"
    if [ "$SHFMT_FORCE" == "true" ]; then
        echo "$(tput setaf 1)ERROR: $0: no shfmt binary in PATH"
        exit 1
    fi
fi
