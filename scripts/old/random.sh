#!/usr/bin/sh

# 10/16/25
# Sokoloft

# Check that argument is a positive integer
if [[ "$1" =~ ^[1-9][0-9]*$ ]]; then
    # Generate and print random alphanumeric string of given length
    echo
    tr -dc 'A-Za-z0-9' </dev/urandom | head -c "$1"; echo
    echo
else
    echo "Usage: Requires positive integer." >&2
    exit 1
fi

exit 0
