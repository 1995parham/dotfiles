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
    # shellcheck disable=2016
    grep -h 'session_name:' "${yaml_files[@]}" 2>/dev/null | cut -d':' -f2 | awk '{$1=$1;print}' | sort -u |
        fzf --color=fg:#ffa500,hl:#a9a9a9,prompt:#adff2f,separator:#ffe983,info:#ffe2ec \
            --preview='bat -f $(grep -l {} '"${yaml_files[*]}"' 2>/dev/null | head -1)' || true
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
    if [ -n "$KITTY_WINDOW_ID" ]; then
        echo "kitty"
        return
    fi

    if [ -n "$WEZTERM_PANE" ]; then
        echo "wezterm"
        return
    fi

    echo "unknown"
}

# using commands are better because tmux can be shared between different
# terminal emulators and this will mess up the environment variables.
cmd="tmuxp load \"$path\" -y -d && tmux a -t \"$layout\""

if [[ "${OSTYPE}" == "darwin"* ]]; then
    bash_path="$(command -v bash)"
    current_terminal=$(detect_terminal)

    echo "$current_terminal"

    if [[ "$current_terminal" == "WezTerm" ]] && command -v wezterm &>/dev/null; then
        echo "$cmd"
        wezterm cli spawn -- "$bash_path" -ilc "$cmd"
    elif [[ "$current_terminal" == "kitty" ]] && command -v kitty &>/dev/null; then
        echo "$cmd"
        kitty @ launch --type=tab -- "$bash_path" -ilc "$cmd"
    else
        # Fallback: run directly if no supported terminal emulator detected
        tmuxp load "$path" -y
    fi
else
    tmuxp load "$path" -y
fi
