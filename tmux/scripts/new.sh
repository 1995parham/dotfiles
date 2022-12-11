#!/bin/bash
set -e

project=$(fd -tdirectory -H ^\.git$ ~/Documents/Git -x dirname | fzf)

echo "$project"

tmux new-window -k -c "$project" -t "$(basename "$project")" -n "$(basename "$project")" ||
	tmux new-window -c "$project" -n "$(basename "$project")"
tmux split-window -c "$project"
tmux split-window -c "$project"
tmux split-window -c "$project" "git project && $SHELL"
tmux select-layout -t "$(basename "$project")" tiled
