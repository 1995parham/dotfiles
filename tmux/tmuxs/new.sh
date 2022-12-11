#!/bin/bash
set -e

project=$(
	fd -tdirectory -H ^\.git$ ~/Documents/Git -x dirname |
		fzf --color=fg:#ffa500,hl:#a9a9a9,prompt:#adff2f,separator:#ffe983,info:#ffe2ec \
			--preview="onefetch {}; tokei {}"
)

echo "$project"

tmux new-window -k -c "$project" -t "$(basename "$project")" -n "$(basename "$project")" ||
	tmux new-window -c "$project" -n "$(basename "$project")"
tmux split-window -c "$project"
tmux split-window -c "$project"
tmux split-window -c "$project" "git project && $SHELL"
tmux select-layout -t "$(basename "$project")" tiled
tmux select-pane -t 0
