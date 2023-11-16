#!/bin/bash

# https://stackoverflow.com/questions/3822621/how-to-exit-if-a-command-failed
set -eu
set -o pipefail

main() {
	uptime |
		awk -F, '{print $1,$2}' |
		sed 's/:/h /g;s/^.*up *//; s/ *[0-9]* user.*//;s/[0-9]$/&m/;s/ day. */d /g'
}

main
