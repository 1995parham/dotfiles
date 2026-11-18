#!/usr/bin/env bash
set -e

host=$(
    # shellcheck disable=2046
    grep '^Host' $(fd . ~/.ssh) 2>/dev/null | grep -v '[?*]' | cut -d ' ' -f 2- | sort -u |
        fzf --color=fg:#ffa500,hl:#a9a9a9,prompt:#adff2f,separator:#ffe983,info:#ffe2ec
)

# Ghostty has no CLI for opening a tab; on macOS it is scripted with
# AppleScript. Opens a tab in the front window, types the command into its
# shell and titles the tab.
ghostty_new_tab() {
    osascript - "$1" "$2" <<'APPLESCRIPT'
on run argv
    tell application "Ghostty"
        set cfg to new surface configuration
        set initial input of cfg to (item 1 of argv) & linefeed
        if (count of windows) is 0 then
            set w to new window with configuration cfg
            set t to selected tab of w
        else
            set t to new tab in front window with configuration cfg
        end if
        set name override of t to item 2 of argv
    end tell
end run
APPLESCRIPT
}

if [[ "$OSTYPE" == "darwin"* ]]; then
    # tmux can be shared between terminal emulators, so ask it which one the
    # current client runs in instead of checking what is installed.
    eval "$(tmux show-environment -s "GHOSTTY_RESOURCES_DIR" 2>/dev/null || true)"

    if [[ -n "${GHOSTTY_RESOURCES_DIR:+set}" ]]; then
        ghostty_new_tab "ssh $host" "ssh @ $host"
    elif [[ -n "$(command -v wezterm)" ]]; then
        pane_id=$(wezterm cli spawn)
        wezterm cli send-text --pane-id "${pane_id}" --no-paste "$(printf "%s\r" "ssh $host")"
        wezterm cli activate-pane --pane-id "${pane_id}"
        wezterm cli set-tab-title --pane-id "${pane_id}" "ssh @ $host"
    elif [[ -n "$(command -v kitty)" ]]; then
        kitty @ launch --type=tab kitten ssh "$host"
    fi
else
    # . character has special meaning for tmux, it uses
    # that for separating window from pane.
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
