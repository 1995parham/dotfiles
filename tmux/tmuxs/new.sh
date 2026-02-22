#!/usr/bin/env bash
set -e

# these repositories are also searched during the search
# of projects.
mono_repositories=()

# a global variable that points to tmuxs root directory.
tmuxs_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=./scripts/lib/message.sh
source "$tmuxs_root/../../scripts/lib/main.sh"

# setup commands run once in pane 0 (e.g. dependency install)
setup_commands=()
# activate commands run in all panes (e.g. venv activation)
activate_commands=()

# window name suffix emoji
window_emoji="📁"

# fzf color scheme
fzf_colors="fg:#fab387,fg+:#a6e3a1,bg+:#313244,hl:#fab387,hl+:#f9e2af,info:#a6e3a1,prompt:#fab387,pointer:#a6e3a1,marker:#fab387,spinner:#a6e3a1,header:#fab387,separator:#585b70,border:#a6e3a1"

project=$(
    fd -H -t d '^\.git$' ~/Documents/Git --max-depth 4 -x dirname |
        fzf --color="$fzf_colors" \
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
            fzf --color="$fzf_colors" \
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

sessions=$(tmux list-sessions 2>/dev/null | sed 's/: .*$//' || echo "")

current_session=$(
    printf "%s\n[new]" "$sessions" |
        fzf \
            --color="$fzf_colors" \
            --query "$current_session" \
            --preview="tmux capture-pane -ep -t {}"
)

if [ "$current_session" == "[new]" ]; then
    read -r -p "please enter the new session name: " new_session
    if [ -n "$new_session" ]; then
        tmux new-session -s "$new_session" -d -n 'scratch' -c "$HOME/Downloads"
        current_session="$new_session"
    else
        exit 0
    fi
fi

if ! cd "$project"; then
    message 'tmux' "failed to change directory to $project" 'error'
    exit 1
fi

# detect python environment and defer dependency installation to run inside the pane.
# pipenv automatically uses pyenv for python version management.
if [ -f Pipfile ]; then
    pipenv=""

    if command -v pipx &>/dev/null; then
        message 'tmux' 'pipx is installed and we are using it to run pipenv' 'warn'
        pipenv="pipx run pipenv"
    elif command -v pipenv &>/dev/null; then
        pipenv="pipenv"
    fi

    if [ -n "$pipenv" ]; then
        message 'tmux' "setup project based on pipenv ($pipenv)" 'warn'
        setup_commands+=("$pipenv sync --dev")
        activate_commands+=("source \$($pipenv --venv)/bin/activate")
    fi
elif [ -f poetry.lock ]; then
    poetry=""

    if command -v pipx &>/dev/null; then
        message 'tmux' 'pipx is installed and we are using it to run poetry' 'warn'
        poetry="pipx run poetry"
    elif command -v poetry &>/dev/null; then
        poetry="poetry"
    fi

    if [ -n "$poetry" ]; then
        message 'tmux' "setup project based on poetry ($poetry)" 'warn'
        setup_commands+=("$poetry install --verbose")
        activate_commands+=("source \$($poetry env info --path)/bin/activate")
    fi
# install python requirements using requirements.txt
# and using pyenv manually to install required python version.
elif [ -f requirements.txt ]; then
    if [ ! -d '.venv' ]; then
        if command -v pyenv &>/dev/null && [ -f .python-version ]; then
            pyenv install
            pyenv exec python -mvenv .venv
        elif command -v python3 &>/dev/null; then
            python3 -mvenv .venv
        else
            python -mvenv .venv
        fi
    fi
    if [ -d '.venv' ]; then
        setup_commands+=('source .venv/bin/activate && pip install -r requirements.txt')
        activate_commands+=('source .venv/bin/activate')
    fi
# detect uv based on having uv.lock in the project root.
elif [ -f uv.lock ]; then
    uv=""

    if command -v pipx &>/dev/null; then
        message 'tmux' 'pipx is installed and we are using it to run uv' 'warn'
        uv="pipx run uv"
    elif command -v uv &>/dev/null; then
        uv="uv"
    fi

    if [ -n "$uv" ]; then
        message 'tmux' "setup project based on uv ($uv)" 'warn'
        setup_commands+=("$uv sync")
        activate_commands+=('source .venv/bin/activate')
    fi
fi

base_name="$name"
if tmux has-session -t "$current_session:=$base_name $window_emoji" &>/dev/null; then
    base_name="${org_name}/${name}"
fi
prefix=0
while tmux has-session -t "$current_session:=$base_name $window_emoji" &>/dev/null; do
    base_name="${org_name}/${name}_${prefix}"
    prefix=$((prefix + 1))
    if [ "$prefix" -ge 100 ]; then
        message 'tmux' "failed to find unique window name after 100 attempts" 'error'
        exit 1
    fi
done
name="$base_name"

name="${name} ${window_emoji}"

tmux new-window -t "$current_session" -c "$project" -n "$name" \; \
    split-window -t "$current_session:$name" -c "$project" \; \
    select-pane -t "$current_session:$name.0" \; \
    split-window -h -t "$current_session:$name" -c "$project"

# run setup commands (dependency install) only in pane 0
for command in "${setup_commands[@]}"; do
    tmux send-keys -t "$current_session:$name.0" "$command" Enter
done

# run activate commands (venv activation) in all panes
num_panes=$(tmux list-panes -t "$current_session:$name" -F '#{pane_index}' | wc -l | tr -d ' ')
for i in $(seq 0 $((num_panes - 1))); do
    for command in "${activate_commands[@]}"; do
        tmux send-keys -t "$current_session:$name.$i" "$command" Enter
    done
done

tmux send-keys -t "$current_session:$name.0" "clear && onefetch" Enter
tmux send-keys -t "$current_session:$name.1" "clear && tokei" Enter
tmux send-keys -t "$current_session:$name.2" "nvim" Enter
tmux select-pane -t "$current_session:$name.0"
