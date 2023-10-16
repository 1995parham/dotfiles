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
		fd -tdirectory . "$project" -I -d 1 -x basename | cat - <(echo ".") |
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

# install python requirements using Pipenv
# and it automatically use pyenv for python version management.
if [ -f Pipfile ]; then
	pipenv=""

	if [[ "$(command -v pipx)" ]]; then
		message 'tmux' 'pipx is installed and we are using it to run pipenv' 'warn' && sleep 5
		pipenv="pipx run pipenv"
	elif [[ "$(command -v pipenv)" ]]; then
		pipenv="pipenv"
	fi

	if [ -n "$pipenv" ]; then
		message 'tmux' "setup project base on pipenv ($pipenv)" 'warn' && sleep 5
		bash -c "$pipenv sync --verbose --dev" || msg 'tmux' 'pipenv requirement installation failed' 'error'

		# shellcheck disable=2016
		commands+=('pipenv shell --fancy' "${commands[@]}")
	fi
fi

if [ -f poetry.lock ]; then
	poetry=""

	if [[ "$(command -v pipx)" ]]; then
		message 'tmux' 'pipx is installed and we are using it to run poetry' 'warn' && sleep 5
		poetry="pipx run poetry"
	elif [[ "$(command -v poetry)" ]]; then
		poetry="poetry"
	fi

	if [ -n "$poetry" ]; then
		message 'tmux' "setup project base on poetry ($poetry)" 'warn' && sleep 5
		bash -c "$poetry install --verbose" || msg 'tmux' 'poetry requirement installation failed' 'error'

		# shellcheck disable=2016
		commands+=('source "$(poetry env info --path)/bin/activate"' "${commands[@]}")
	fi
fi

# install python requirements using requirements.txt
# and using pyenv manually to install required python version.
if [ -f requirements.txt ]; then
	if [ ! -d '.venv' ]; then
		if [[ "$(command -v pyenv)" ]] && [ -f .python-version ]; then
			pyenv install
			pyenv exec python -mvenv .venv
		else
			python -mvenv .venv
		fi
	fi

	if [ -d '.venv' ]; then
		commands+=('source .venv/bin/activate')

		# shellcheck disable=1091
		source '.venv/bin/activate' && pip install -r requirements.txt && deactivate
	fi
fi

cd -

prefix=0
while tmux has-session -t "$current_session:=$name" &>/dev/null; do
	name="${name}_${prefix}"
	prefix=$((prefix + 1))
done

tmux new-window -t "$current_session" -c "$project" -n "$name" "$(printf "%s;" "${commands[@]}")$SHELL"
# show project information on the last pane. this doesn't work with pipenv shell
# so we don't have information on pythonic projects.
# commands+=("git project")
tmux split-window -t "$current_session:$name" -c "$project" "$(printf "%s;" "${commands[@]}")$SHELL"
tmux split-window -h -t "$current_session:$name" -c "$project" "$(printf "%s;" "${commands[@]}")$SHELL"
# I am switching to use neovim more than tmux so I am going to use 3 panes instead of 4.
# tmux select-layout -t "$current_session:$name" tiled
tmux send-keys -t "$current_session:$name.0" 'nvim' Enter
tmux select-pane -t "$current_session:$name.0"
tmux resize-pane -Z -t "$current_session:$name.0"
