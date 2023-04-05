#!/bin/bash
set -e

# a global variable that points to tmuxs root directory.
tmuxs_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=./scripts/lib/proxy.sh
source "$tmuxs_root/../../scripts/lib/proxy.sh"

project=$(
	fd -tdirectory -H ^\.git$ ~/Documents/Git -x dirname |
		fzf --color=fg:#ffa500,hl:#a9a9a9,prompt:#adff2f,separator:#ffe983,info:#ffe2ec \
			--preview="onefetch {}; tokei {}"
)

# . character has special meaning for tmux, it uses
# it for separating window from pane.
name="$(basename "$project" | tr '.' '_')"
current_session="$(tmux display-message -p '#S')"

sessions=$(tmux list-sessions | sed 's/: .*$//')

current_session=$(
	printf "%s\n[new]" "$sessions" |
		fzf \
			--color=fg:#ffa500,hl:#a9a9a9,prompt:#adff2f,separator:#ffe983,info:#ffe2ec \
			--query "$current_session" \
			--preview="tmux capture-pane -ep -t {}"
)

if [ "$current_session" == "[new]" ]; then
	read -r -p "please enter the new session name: " new_session
	if [ -n "$new_session" ]; then
		tmux new-session -s "$new_session" -d -n 'scratch' -c "$HOME/Downloads"
		current_session="$new_session"
	else
		return 0
	fi
fi

cd "$project" || exit

(which onefetch && onefetch) || true
read -n 1 -s -r -p "press any key to continue"
echo
(which tokei && tokei) || true
read -n 1 -s -r -p "press any key to continue"
echo

if [ -f Pipfile ]; then
	if [[ "$(command -v pipenv)" ]]; then
		pipenv install --verbose --dev --skip-lock

		# shellcheck disable=2016
		commands+=('pipenv shell --fancy' "${commands[@]}")
	fi
fi

cd -

tmux kill-window -t "$current_session:=$name" || true
tmux new-window -t "$current_session" -c "$project" -n "$name" "$(printf "%s;" "${commands[@]}")$SHELL"
tmux split-window -t "$current_session:$name" -c "$project" "$(printf "%s;" "${commands[@]}")$SHELL"
tmux split-window -t "$current_session:$name" -c "$project" "$(printf "%s;" "${commands[@]}")$SHELL"
# show project information on the last pane. this doesn't work with pipenv shell
# so we don't have information on pythonic projects.
# commands+=("git project")
tmux split-window -t "$current_session:$name" -c "$project" "$(printf "%s;" "${commands[@]}")$SHELL"
tmux select-layout -t "$current_session:$name" tiled
tmux select-pane -t 0
