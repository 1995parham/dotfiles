#!/usr/bin/env bash

function run_editor_before() {
	# TODO: I cannot find any way for implementing it.
	# 9 Nov 2023
	echo "501: NOT IMPLEMENTED"
	return 1
}

function run_verbose() {
	print -S "echo $*" 2>/dev/null || history -s "$*"
	action "run" "$*"
	"$@"
}
