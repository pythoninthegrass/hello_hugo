#!/usr/bin/env bash

GIT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)"
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
if [ -n "$GIT_ROOT" ]; then
	TLD="$GIT_ROOT"
else
	TLD="${SCRIPT_DIR}"
fi

./${TLD}/gen_config.sh -e

if [ -z "$NGINX_DIR" ]; then
	echo "NGINX_DIR is not set"
	exit 1
fi

cmd="rsync -arvhW --no-compress --progress --stats --delete"
$cmd ${TLD}/public/ "${NGINX_DIR}"
