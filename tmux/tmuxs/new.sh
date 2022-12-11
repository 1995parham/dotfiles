#!/bin/bash
set -e

project=$(
	fd -tdirectory -H ^\.git$ ~/Documents/Git -x dirname |
		fzf --color=fg:#ffa500,hl:#a9a9a9,prompt:#adff2f,separator:#ffe983,info:#ffe2ec \
			--preview="onefetch {}; tokei {}"
)

name="$(basename "$project")"

cd "$project" || exit

if [ -f Pipfile ]; then
	if [[ "$(command -v pipenv)" ]]; then
		pipenv install --dev --skip-lock
		# shellcheck disable=2016
		commands=('[ -d $(pipenv --venv) ] && source $(pipenv --venv)/bin/activate && reset' "${commands[@]}")
	fi
fi

cd -

tmux kill-window -t "$name" || true
tmux new-window -c "$project" -n "$name" "$(printf "%s;" "${commands[@]}")$SHELL"
tmux split-window -c "$project" "$(printf "%s;" "${commands[@]}")$SHELL"
tmux split-window -c "$project" "$(printf "%s;" "${commands[@]}")$SHELL"
commands+=("git project")
tmux split-window -c "$project" "$(printf "%s;" "${commands[@]}")$SHELL"
tmux select-layout -t "$(basename "$project")" tiled
tmux select-pane -t 0
