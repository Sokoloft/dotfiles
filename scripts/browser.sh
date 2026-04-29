#!/usr/bin/env bash
#
# Open Tabliss in Librewolf
# 4/29/26
#

# Statics
BROWSER=librewolf
TABLISS_URL=$(< tabliss_str.txt)

case "${1:-}" in
    -w|--window)
        $BROWSER --new-window "$TABLISS_URL"
        ;;
    -t|--tab|"")
        $BROWSER --new-tab "$TABLISS_URL"
        ;;
    *)
        echo "Usage: $0 [--tab|--window]"
        exit 1
        ;;
esac

exit 0
