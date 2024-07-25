#!/usr/bin/env bash

GIT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)"
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
if [ -n "$GIT_ROOT" ]; then
	TLD="$GIT_ROOT"
else
	TLD="${SCRIPT_DIR}"
fi

ENV_FILE="${TLD}/.env"

if [ ! -f "$ENV_FILE" ]; then
	echo "No .env file found in the root of the project"
	exit 1
fi

read_env() {
	# https://stackoverflow.com/a/55715596
	echo "Reading .env file"
	while read -r line; do
		key="${line%%=*}"
		val="${line#*=}"
		export "$key"="$val"
	done < "$ENV_FILE"
}

gen_config() {
	TEMPLATE="${TLD}/hugo.tmpl"
	CONFIG="${TLD}/hugo.toml"

	jinja2 "$TEMPLATE" > "$CONFIG"

	echo "Generated config file at ${CONFIG}"
}

main() {
	if [ $# -eq 0 ]; then
		read_env
		gen_config
	else
		while (( "$#" )); do
			case "$1" in
				-e|--env)
					read_env
					shift
					;;
				-c|--config)
					gen_config
					shift
					;;
				*)
					echo "Unknown argument: $1"
					exit 1
					;;
			esac
		done
	fi
}
