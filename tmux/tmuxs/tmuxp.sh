#!/usr/bin/env bash
set -euo pipefail

config_dir="$HOME/.config/tmuxp"

# Find all yaml files
mapfile -t yaml_files < <(fd -e yaml . "$config_dir" 2>/dev/null || find "$config_dir" -name "*.yaml" 2>/dev/null)

if [ ${#yaml_files[@]} -eq 0 ]; then
    echo "No tmuxp config files found in $config_dir" >&2
    exit 1
fi

# Select layout using fzf
layout=$(
    grep -h 'session_name:' "${yaml_files[@]}" 2>/dev/null | cut -d':' -f3 | awk '{$1=$1;print}' | sort -u |
        fzf --color=fg:#ffa500,hl:#a9a9a9,prompt:#adff2f,separator:#ffe983,info:#ffe2ec \
            --preview='bat -f $(grep -l "^session_name: {}" '"${yaml_files[*]}"' 2>/dev/null | head -1)' || true
)

if [ -z "$layout" ]; then
    exit 1
fi

# Find the config file for the selected layout
path=""
for file in "${yaml_files[@]}"; do
    if grep -q "^session_name: $layout\$" "$file" 2>/dev/null; then
        path="$file"
        break
    fi
done

if [ -z "$path" ] || [ ! -f "$path" ]; then
    echo "Config file not found for layout: $layout" >&2
    exit 1
fi

# Detect current terminal emulator
detect_terminal() {
    # Check TERM_PROGRAM first (most reliable)
    if [ -n "${TERM_PROGRAM:-}" ]; then
        echo "$TERM_PROGRAM"
        return
    fi

    # Check process tree for terminal emulator
    local ppid=$$
    while [ "$ppid" -gt 1 ]; do
        local process_name
        process_name=$(ps -p "$ppid" -o comm= 2>/dev/null | tail -1)

        case "$process_name" in
            *wezterm*|*wezterm-gui*)
                echo "WezTerm"
                return
                ;;
            *kitty*)
                echo "kitty"
                return
                ;;
        esac

        ppid=$(ps -p "$ppid" -o ppid= 2>/dev/null | tr -d ' ')
        [ -z "$ppid" ] && break
    done

    echo "unknown"
}

# using commands are better because tmux can be shared between different
# terminal emulators and this will mess up the environment variables.
cmd="tmuxp load \"$path\" -y -d && tmux a -t \"$layout\""

if [[ "${OSTYPE}" == "darwin"* ]]; then
    bash_path="$(command -v bash)"
    current_terminal=$(detect_terminal)

    if [[ "$current_terminal" == "WezTerm" ]] && command -v wezterm &>/dev/null; then
        echo "$cmd"
        wezterm cli spawn -- "$bash_path" -ilc "$cmd"
    elif [[ "$current_terminal" == "kitty" ]] && command -v kitty &>/dev/null; then
        echo "$cmd"
        kitty @ launch --type=tab -- "$bash_path" -ilc "$cmd"
    else
        # Fallback: run directly if no supported terminal emulator detected
        tmuxp load "$path" -y
        tmux attach-session -t "$layout"
    fi
else
    tmuxp load "$path" -y
    tmux attach-session -t "$layout"
fi
