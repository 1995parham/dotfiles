#!/bin/bash
set -e

project=$(
	fd -tdirectory -H ^\.git$ ~/Documents/Git -x dirname |
		fzf --color=fg:#ffa500,hl:#a9a9a9,prompt:#adff2f,separator:#ffe983,info:#ffe2ec \
			--preview="onefetch {}; tokei {}"
)

# . character has special meaning for tmux, it uses
# it for separating window from pane.
name="$(basename "$project" | tr '.' '_')"
current_session="$(tmux display-message -p '#S')"

cd "$project" || exit

if [ -f Pipfile ]; then
	if [[ "$(command -v pipenv)" ]]; then
		pipenv install --dev --skip-lock
		# shellcheck disable=2016
		commands=('[ -d $(pipenv --venv) ] && source $(pipenv --venv)/bin/activate && reset' "${commands[@]}")
	fi
fi

cd -

tmux kill-window -t "$current_session:$name" || true
tmux new-window -t "$current_session" -c "$project" -n "$name" "$(printf "%s;" "${commands[@]}")$SHELL"
tmux split-window -t "$current_session:$name" -c "$project" "$(printf "%s;" "${commands[@]}")$SHELL"
tmux split-window -t "$current_session:$name" -c "$project" "$(printf "%s;" "${commands[@]}")$SHELL"
commands+=("git project")
tmux split-window -t "$current_session:$name" -c "$project" "$(printf "%s;" "${commands[@]}")$SHELL"
tmux select-layout -t "$current_session:$name" tiled
tmux select-pane -t 0
