#!/bin/bash
# 
# Copyright (c) ospo.ch & authors
# SPDX-License-Identifier: MIT
# 
# This script takes an argument [filename] and creates
# several markdown files in the current directory:
#
#       - filename.md
#       - filename.de.md
#       - filename.fr.md
#       - filename.it.md
#       - filename.rm.md
#
# Each file contains markdown content with navigation links
# to each language.

set -euo pipefail

LANGUAGES=("de" "fr" "it" "rm")

EXIT_CODE=0

help() {
    # Display help 
    echo "ospo_new - command line content management tool for ospo.ch"
    echo
    echo "Usage:"
    echo
    echo "          ospo_new [filename]"
    echo
}

fail() { 
    echo "$@"
    EXIT_CODE=1
}


if [ $# -lt 1 ]; then 
    help
    exit 1
fi

readonly FILE_NAME=$1

if [ -f "$FILE_NAME.md" ]; then
    echo "$FILE_NAME.md already exists"
    exit 1
fi

CONTENT="[DE](./$FILE_NAME.de.md) [FR](./$FILE_NAME.fr.md) [IT](./$FILE_NAME.it.md) [RM](./$FILE_NAME.rm.md) [EN](./$FILE_NAME.md)"

# Create default english without language extension
echo "$CONTENT" > "$FILE_NAME.md"

# Create localized versions
for language in "${LANGUAGES[@]}"; do 
    {
        echo "$CONTENT" > "$FILE_NAME.$language.md"
    } || fail "failed creating file $language";
done

exit "$EXIT_CODE"