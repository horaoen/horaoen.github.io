#!/usr/bin/env bash

set -euo pipefail

REMOTE_HOST="${REMOTE_HOST:-47.94.7.180}"
REMOTE_USER="${REMOTE_USER:-root}"
REMOTE_PASS="${REMOTE_PASS:-}"
LOCAL_DIR="${LOCAL_DIR:-public}"
REMOTE_DIR="${REMOTE_DIR:-/var/www/zola}"
BASE_URL="${BASE_URL:-http://47.94.7.180}"

usage() {
	cat <<'EOF'
Usage:
  scripts/deploy_zola.sh [options]

Options:
  --host <ip_or_host>     Remote host (default: 47.94.7.180)
  --user <username>       Remote user (default: root)
  --pass <password>       Remote password (not recommended on CLI)
  --local <path>          Local folder to upload (default: public)
  --remote <path>         Remote deploy path (default: /var/www/zola)
  --base-url <url>        Base URL for zola build (default: http://47.94.7.180)
  -h, --help              Show help

Environment overrides:
  REMOTE_HOST, REMOTE_USER, REMOTE_PASS, LOCAL_DIR, REMOTE_DIR, BASE_URL

Password source priority:
  1) --pass
  2) REMOTE_PASS env
  3) Interactive hidden prompt
EOF
}

while [ $# -gt 0 ]; do
	case "$1" in
	--host)
		REMOTE_HOST="$2"
		shift 2
		;;
	--user)
		REMOTE_USER="$2"
		shift 2
		;;
	--pass)
		REMOTE_PASS="$2"
		shift 2
		;;
	--local)
		LOCAL_DIR="$2"
		shift 2
		;;
	--remote)
		REMOTE_DIR="$2"
		shift 2
		;;
	--base-url)
		BASE_URL="$2"
		shift 2
		;;
	-h | --help)
		usage
		exit 0
		;;
	*)
		echo "Error: unknown option '$1'"
		usage
		exit 1
		;;
	esac
done

if [ -z "$REMOTE_PASS" ]; then
	if [ -t 0 ]; then
		printf "Remote password for %s@%s: " "$REMOTE_USER" "$REMOTE_HOST"
		stty -echo
		IFS= read -r REMOTE_PASS
		stty echo
		printf "\n"
	else
		echo "Error: password not provided. Use REMOTE_PASS env or --pass."
		exit 1
	fi
fi

if ! command -v sshpass >/dev/null 2>&1; then
	echo "Error: sshpass is not installed. Install it first."
	exit 1
fi

if ! command -v zola >/dev/null 2>&1; then
	echo "Error: zola is not installed. Install it first."
	exit 1
fi

echo "[0/3] Building site with zola"
zola build --base-url "$BASE_URL"

if [ ! -d "$LOCAL_DIR" ]; then
	echo "Error: local directory '$LOCAL_DIR' does not exist after zola build."
	exit 1
fi

SSH_OPTS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

echo "[1/3] Backing up remote directory: $REMOTE_DIR"
sshpass -p "$REMOTE_PASS" ssh $SSH_OPTS "$REMOTE_USER@$REMOTE_HOST" \
	"ts=\$(date +%Y%m%d%H%M%S); if [ -d '$REMOTE_DIR' ]; then mv '$REMOTE_DIR' '${REMOTE_DIR}_backup_'\$ts; fi; mkdir -p '$REMOTE_DIR'"

echo "[2/3] Uploading $LOCAL_DIR to $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR"
sshpass -p "$REMOTE_PASS" scp -r $SSH_OPTS "$LOCAL_DIR/." "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR/"

echo "[3/3] Verifying deploy result"
sshpass -p "$REMOTE_PASS" ssh $SSH_OPTS "$REMOTE_USER@$REMOTE_HOST" \
	"ls -ld '$REMOTE_DIR' && echo 'File count:' && ls '$REMOTE_DIR' | wc -l"

echo "Done. Deployment target is: $REMOTE_DIR"
