#!/usr/bin/env python3

import argparse
import string
import secrets
import sys
import subprocess
import shutil
import platform

VERSION = "1.0.0"


def build_pool(use_lower, use_upper, use_digits, use_symbols):
    pool = ""
    sets = []

    if use_lower:
        pool += string.ascii_lowercase
        sets.append(string.ascii_lowercase)
    if use_upper:
        pool += string.ascii_uppercase
        sets.append(string.ascii_uppercase)
    if use_digits:
        pool += string.digits
        sets.append(string.digits)
    if use_symbols:
        pool += string.punctuation
        sets.append(string.punctuation)

    return pool, sets


def generate_string(length, pool, sets=None, require_each=False):
    if not pool:
        print("Error: No character sets selected.", file=sys.stderr)
        sys.exit(1)

    result = []

    if require_each and sets:
        if length < len(sets):
            print("Error: length too short for --require-each", file=sys.stderr)
            sys.exit(1)

        for s in sets:
            result.append(secrets.choice(s))

        remaining = length - len(result)
    else:
        remaining = length

    result.extend(secrets.choice(pool) for _ in range(remaining))
    secrets.SystemRandom().shuffle(result)

    return ''.join(result)


def copy_to_clipboard(text):
    system = platform.system()

    try:
        if system == "Linux":
            if shutil.which("wl-copy"):
                subprocess.run(["wl-copy"], input=text.encode(), check=True)
            elif shutil.which("xclip"):
                subprocess.run(["xclip", "-selection", "clipboard"], input=text.encode(), check=True)
            elif shutil.which("xsel"):
                subprocess.run(["xsel", "--clipboard", "--input"], input=text.encode(), check=True)
            else:
                raise RuntimeError("No clipboard utility found (install wl-clipboard, xclip, or xsel)")

        elif system == "Darwin":
            subprocess.run(["pbcopy"], input=text.encode(), check=True)

        elif system == "Windows":
            subprocess.run(["clip"], input=text.encode(), check=True)

        else:
            raise RuntimeError(f"Unsupported OS: {system}")

    except Exception as e:
        print(f"Clipboard error: {e}", file=sys.stderr)
        sys.exit(1)


def main():
    parser = argparse.ArgumentParser(
        description="Generate random strings from CLI"
    )

    # Positional length (optional)
    parser.add_argument(
        "length_pos",
        nargs="?",
        type=int,
        help="Length of each string (positional)"
    )

    # Optional flag version of length
    parser.add_argument(
        "-l", "--length",
        type=int,
        help="Length of each string (overrides positional)"
    )

    parser.add_argument(
        "-n", "--count",
        type=int,
        default=3,
        help="Number of strings to generate (default: 3)"
    )

    parser.add_argument("--lower", action="store_true")
    parser.add_argument("--upper", action="store_true")
    parser.add_argument("--digits", action="store_true")
    parser.add_argument("--symbols", action="store_true")
    parser.add_argument("--all", action="store_true")

    parser.add_argument("--require-each", action="store_true")

    parser.add_argument("--clipboard", action="store_true")

    parser.add_argument(
        "-v", "--version",
        action="version",
        version=f"%(prog)s {VERSION}"
    )

    args = parser.parse_args()

    # Resolve length priority:
    # 1. --length flag
    # 2. positional
    # 3. default = 32
    if args.length is not None:
        length = args.length
    elif args.length_pos is not None:
        length = args.length_pos
    else:
        length = 32

    # Default behavior: lower + upper + digits
    if args.all:
        args.lower = args.upper = args.digits = args.symbols = True
    elif not (args.lower or args.upper or args.digits or args.symbols):
        args.lower = args.upper = args.digits = True

    pool, sets = build_pool(
        args.lower,
        args.upper,
        args.digits,
        args.symbols
    )

    results = [
        generate_string(length, pool, sets, args.require_each)
        for _ in range(args.count)
    ]

    output = "\n".join(results)
    print(f"\n{output}\n")

    if args.clipboard:
        copy_to_clipboard(output)


if __name__ == "__main__":
    main()