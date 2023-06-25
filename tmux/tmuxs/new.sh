#!/bin/bash
set -e

mono_repositories=(
	"petropower/trex"
	"offerland/root"
)

# a global variable that points to tmuxs root directory.
tmuxs_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=./scripts/lib/message.sh
source "$tmuxs_root/../../scripts/lib/message.sh"

project=$(
	fd -tdirectory -H ^\.git$ ~/Documents/Git -x dirname |
		fzf --color=fg:#ffa500,hl:#a9a9a9,prompt:#adff2f,separator:#ffe983,info:#ffe2ec \
			--preview="onefetch {}; tokei {}"
)

# check the repository is monorepo or not.
# in case of being mono repo we need to ask again for the sub-project.
project_name="$(basename "$project")"
org_name="$(basename "$(dirname "$project")")"
sub_project=""
if [[ " ${mono_repositories[*]} " == *"$org_name/$project_name"* ]]; then
	sub_project=$(
		fd -tdirectory . "$project" -d 1 -x basename | cat - <(echo ".") |
			fzf --color=fg:#ffa500,hl:#a9a9a9,prompt:#adff2f,separator:#ffe983,info:#ffe2ec \
				--preview="onefetch $project/{}; tokei $project/{}"
	)
	if [ "$sub_project" == "." ]; then
		sub_project=""
	fi
fi

# . character has special meaning for tmux, it uses
# it for separating window from pane.
name="$(basename "$project" | tr '.' '_')"
if [ -n "$sub_project" ]; then
	name="${name}_${sub_project}"
	project="$project/$sub_project"
fi
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
	pipenv=""

	if [[ "$(command -v pipx)" ]]; then
		message 'tmux' 'pipx is installed and we are using it to run pipenv' 'warn' && sleep 5
		pipenv="pipx run pipenv"
	fi

	if [[ "$(command -v pipenv)" ]]; then
		pipenv="pipenv"
	fi

	if [ -n "$pipenv" ]; then
		message 'tmux' "setup project base on pipenv ($pipenv)" 'warn' && sleep 5
		"$pipenv" install --verbose --dev

		# shellcheck disable=2016
		commands+=('pipenv shell --fancy' "${commands[@]}")
	fi
fi

cd -

tmux kill-window -t "$current_session:=$name" &>/dev/null || true
tmux new-window -t "$current_session" -c "$project" -n "$name" "$(printf "%s;" "${commands[@]}")$SHELL"
tmux split-window -t "$current_session:$name" -c "$project" "$(printf "%s;" "${commands[@]}")$SHELL"
tmux split-window -t "$current_session:$name" -c "$project" "$(printf "%s;" "${commands[@]}")$SHELL"
# show project information on the last pane. this doesn't work with pipenv shell
# so we don't have information on pythonic projects.
# commands+=("git project")
tmux split-window -t "$current_session:$name" -c "$project" "$(printf "%s;" "${commands[@]}")$SHELL"
tmux select-layout -t "$current_session:$name" tiled
tmux select-pane -t 0
