#!/usr/bin/env bash
set -e

# a global variable that points to tmuxs root directory.
tmuxs_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=./scripts/lib/proxy.sh
source "$tmuxs_root/../../scripts/lib/proxy.sh"

host=$(
	# shellcheck disable=2046
	grep '^Host' $(fd . ~/.ssh) 2>/dev/null | grep -v '[?*]' | cut -d ' ' -f 2- | sort -u |
		fzf --color=fg:#ffa500,hl:#a9a9a9,prompt:#adff2f,separator:#ffe983,info:#ffe2ec
)

if [[ "$OSTYPE" == "darwin"* ]] &&
	[[ "$(command -v kitty)" ]]; then
	kitty @ launch --type=tab kitten ssh "$host"
else
	# . character has special meaning for tmux, it uses
	# it for separating window from pane.
	name="-|-$(basename "$host" | tr '.' '_')"
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

	tmux kill-window -t "$current_session:=$name" &>/dev/null || true
	tmux new-window -t "$current_session" -c "$HOME/Downloads" -n "$name" "ssh $host"
	tmux split-window -t "$current_session:=$name" -c "$HOME/Downloads" "ssh $host"
	tmux select-pane -t "$current_session:=$name.0"
fi
