#!/usr/bin/env bash

# functions for running commands and adding the actual one
# into the history / or not adding the command it into history.

function run_editor_before() {
    # TODO: I cannot find any way for implementing it.
    # 9 Nov 2023
    echo "501: NOT IMPLEMENTED"
    return 1
}

function run_verbose() {
    print -S "$*" 2>/dev/null || history -s "$*"
    action "run" "$*"
    "$@"
}
