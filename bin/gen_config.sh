#!/usr/bin/env bash

GIT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)"
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
if [ -n "$GIT_ROOT" ]; then
	TLD="$GIT_ROOT"
else
	TLD="${SCRIPT_DIR}"
fi

ENV_FILE="${TLD}/.env"

# https://stackoverflow.com/a/55715596
while read -r line; do
    key="${line%%=*}"
    val="${line#*=}"
    export "$key"="$val"
done < "$ENV_FILE"

TEMPLATE="${TLD}/hugo.tmpl"
CONFIG="${TLD}/hugo.toml"

jinja2 "$TEMPLATE" > "$CONFIG"
