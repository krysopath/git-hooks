#!/bin/bash
# Redirect output to stderr.
#exec 1>&2

# find changed paths that are staged for commit
STAGED="$(git diff --staged --name-only)"

# select those who have 'tests' in path and end on '.sh'
CHANGED="$(grep '^.*\.sh' <<<"$STAGED" || [[ $? == 1 ]])"

LINTER="$(which shellcheck)"
if [ -e "$CHANGED" ]; then
	if [ -e "$LINTER" ]; then
		# we disable these warnings as we want that behaviour for now
		# shellcheck disable=SC2093,SC2086
		exec "$LINTER" -s bash -x $CHANGED
	else
		echo "$(
			tput bold
			tput setaf 1
		)No shellcheck installed"
	fi
fi
