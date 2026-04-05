#!/usr/bin/env bash
#
# Open Tabliss in Firefox and later librewolf
# 4/5/26
#

BROWSER=firefox

# Tabliss URL
TABLISS_URL="moz-extension://ac2de196-9dac-4aa1-b760-b2e72a358555/index.html"


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
