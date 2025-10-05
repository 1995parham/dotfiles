#!/usr/bin/env bash
set -e

# these repositories are also searched during the search
# of projects.
mono_repositories=()

# a global variable that points to tmuxs root directory.
tmuxs_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=./scripts/lib/message.sh
source "$tmuxs_root/../../scripts/lib/main.sh"

# initialize commands array for virtual environment activation
commands=()

# window name suffix emoji
window_emoji="📁"

# fzf color scheme
fzf_colors="fg:#ffa500,hl:#a9a9a9,prompt:#adff2f,separator:#ffe983,info:#ffe2ec"

project=$(
    # -H is not enough for having .git in your search, you need to have -I too.
    fd -tdirectory -tfile -IH ^\.git$ ~/Documents/Git -x dirname |
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

if command -v onefetch &>/dev/null; then
    onefetch || true
    read -n 1 -s -r -p "press any key to continue"
    echo
fi

if command -v tokei &>/dev/null; then
    tokei || true
    read -n 1 -s -r -p "press any key to continue"
    echo
fi

# install python requirements using Pipenv, Poetry, uv or requirements.txt
# pipenv automatically uses pyenv for python version management.
if [ -f Pipfile ]; then
    pipenv=""

    if command -v pipx &>/dev/null; then
        message 'tmux' 'pipx is installed and we are using it to run pipenv' 'warn' && sleep 5
        pipenv="pipx run pipenv"
    elif command -v pipenv &>/dev/null; then
        pipenv="pipenv"
    fi

    if [ -n "$pipenv" ]; then
        message 'tmux' "setup project base on pipenv ($pipenv)" 'warn' && sleep 5
        bash -c "$pipenv sync --dev" || message 'tmux' 'pipenv requirement installation failed' 'error'

        venv_path="$($pipenv --venv)"

        commands=("source $venv_path/bin/activate" "${commands[@]}")
    fi
elif [ -f poetry.lock ]; then
    poetry=""

    if command -v pipx &>/dev/null; then
        message 'tmux' 'pipx is installed and we are using it to run poetry' 'warn' && sleep 5
        poetry="pipx run poetry"
    elif command -v poetry &>/dev/null; then
        poetry="poetry"
    fi

    if [ -n "$poetry" ]; then
        message 'tmux' "setup project base on poetry ($poetry)" 'warn' && sleep 5
        bash -c "$poetry install --verbose" || message 'tmux' 'poetry requirement installation failed' 'error'

        venv_path="$($poetry env info --path)"

        commands=("source $venv_path/bin/activate" "${commands[@]}")
    fi
# install python requirements using requirements.txt
# and using pyenv manually to install required python version.
elif [ -f requirements.txt ]; then
    if [ ! -d '.venv' ]; then
        if command -v pyenv &>/dev/null && [ -f .python-version ]; then
            pyenv install
            pyenv exec python -mvenv .venv
        elif command -v python3 &>/dev/null; then
            # macos still have python3 instead of python because this operating system is
            # garbage.
            python3 -mvenv .venv
        else
            python -mvenv .venv
        fi
    fi
    if [ -d '.venv' ]; then
        commands+=('source .venv/bin/activate')

        # shellcheck disable=1091
        source '.venv/bin/activate' && pip install -r requirements.txt && deactivate
    fi
# detect uv based on having uv.lock in the project root.
elif [ -f uv.lock ]; then
    uv=""

    if command -v pipx &>/dev/null; then
        message 'tmux' 'pipx is installed and we are using it to run uv' 'warn' && sleep 5
        uv="pipx run uv"
    elif command -v uv &>/dev/null; then
        uv="uv"
    fi

    if [ -n "$uv" ]; then
        message 'tmux' "setup project base on uv ($uv)" 'warn' && sleep 5
        bash -c "$uv sync" || message 'tmux' 'uv sync failed' 'error'

        commands+=('source .venv/bin/activate')
    fi
fi

prefix=0
max_retries=100
if tmux has-session -t "$current_session:=$name $window_emoji" &>/dev/null; then
    name="${org_name}/${name}"
fi
while tmux has-session -t "$current_session:=$name $window_emoji" &>/dev/null; do
    name="${name}_${prefix}"
    prefix=$((prefix + 1))
    if [ "$prefix" -ge "$max_retries" ]; then
        message 'tmux' "failed to find unique window name after $max_retries attempts" 'error'
        exit 1
    fi
done

name="${name} ${window_emoji}"

tmux new-window -t "$current_session" -c "$project" -n "$name"
tmux split-window -t "$current_session:$name" -c "$project"
tmux select-pane -t "$current_session:$name.0"
tmux split-window -h -t "$current_session:$name" -c "$project"

# using send command to run the pre-configured commands on all panes
num_panes=3
for i in $(seq 0 $((num_panes - 1))); do
    for command in "${commands[@]}"; do
        tmux send-keys -t "$current_session:$name.$i" "$command" Enter
    done
done

tmux send-keys -t "$current_session:$name.0" "clear && onefetch" Enter
tmux send-keys -t "$current_session:$name.1" "clear && tokei" Enter
tmux send-keys -t "$current_session:$name.2" "nvim" Enter
tmux select-pane -t "$current_session:$name.0"
