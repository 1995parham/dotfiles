#!/usr/bin/env bash

DOTFILES_ROOT=${DOTFILES_ROOT:?"dotfiles root must be set for using aliases"}

# shellcheck source=./scripts/lib/main.sh
source "$DOTFILES_ROOT/scripts/lib/main.sh"

if [ -d "$HOME/.config/aliases" ]; then
    if [ ! -f "$HOME/.config/aliases/kubectl_aliases.sh" ]; then
        curl -#L https://raw.githubusercontent.com/ahmetb/kubectl-aliases/master/.kubectl_aliases >"$HOME/.config/aliases/kubectl_aliases.sh"
    fi

    # shellcheck disable=1090
    for f in "$HOME"/.config/aliases/*.sh; do
        # message 'aliases' "sourcing $f"
        source "$f"
    done
fi

# set personal aliases
# for a full list of active aliases, run `alias`.

# check the weather using wttr.in
function wea() {
    local request="wttr.in/${1-Tehran}?Fqm"
    [ "$(tput cols)" -lt 125 ] && request+='n'
    curl -H "Accept-Language: en" --compressed "$request"
}

# tehran weather in one line
alias wea1='curl -s "wttr.in/{Miami,Austin,Tehran}?format=3&m"'
# current weather in tehran
alias weac='curl -s "wttr.in/Tehran?F0m"'
# 3 day forecast in tehran
alias weaf='curl -s "wttr.in/Tehran?Fqm"'

# watch network connection
alias nw='watch -n 3 -t -d -b "curl -s https://myip.wtf/json"'

if [[ "$OSTYPE" == "darwin"* ]]; then
    # when you live years in Arch and force to use osx
    alias ls="ls --color"
    alias imv="open"
    alias mupdf="open"
    alias wl-copy=pbcopy
    alias wl-paste=pbpaste
    alias mtr="sudo mtr"
    alias python=python3
    alias mcli=mc
fi

alias grep="grep --color=auto"
alias vi="vim"
alias ls-la="ls --color -la"
alias l="ls -la --color"
function ls-() {
    local first_arg="-$1"
    shift
    command ls --color "$first_arg" "$@"
}

# run emacs tui on terminal instead of emacs itself.
alias emacs="emacs -nw"

# connect into the openvpn server on Asus RT-AX88u router at home.
function home-vpn() {
    local operations=("start" "stop")

    if [ -n "$1" ]; then
        operation="$1"
    else
        operation=$(printf '%s\n' "${operations[@]}" |
            fzf --color=fg:#ffa500,hl:#a9a9a9,prompt:#adff2f,separator:#ffe983,info:#ffe2ec)
    fi

    case "$operation" in
    start | up)
        operation="start"
        ;;
    stop | down)
        operation="stop"
        ;;
    esac

    # shellcheck disable=2076
    if [[ ! " ${operations[*]} " =~ " ${operation} " ]]; then
        message 'home-vpn' "$operation is not valid a valid operation"
        return 1
    fi

    case "$operation" in
    "start")
        running 'home-vpn' 'start home connection using openvpn'
        if [[ "$OSTYPE" == "darwin"* ]]; then
            message 'home-vpn' " darwin, using launchctl"
            run_verbose sudo launchctl bootstrap system /Library/LaunchAgents/com.openvpn.home.plist
        elif [[ "$(command -v systemctl)" ]]; then
            message 'home-vpn' " linux, using systemd"
            run_verbose systemctl start openvpn-client@home
        else
            message 'home-vpn' '󰏲 call parham (+98 939 09 09 540)'
        fi

        ;;
    "stop")
        running 'home-vpn' 'stop home connection using openvpn'
        if [[ "$OSTYPE" == "darwin"* ]]; then
            message 'home-vpn' " darwin, using launchctl"
            run_verbose sudo launchctl bootout system /Library/LaunchAgents/com.openvpn.home.plist
        elif [[ "$(command -v systemctl)" ]]; then
            message 'home-vpn' " linux, using systemd"
            run_verbose systemctl stop openvpn-client@home
        else
            message 'home-vpn' '󰏲 call parham (+98 939 09 09 540)'
        fi

        ;;
    esac
}

# show differences between code and code-insiders configuration
function code-settings-diff() {
    config_home=""
    if [[ "$OSTYPE" == "darwin"* ]]; then
        config_home="$HOME/Library/Application Support"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        config_home="$HOME/.config"
    else
        message 'code-settings-diff' '󰏲 call parham (+98 939 09 09 540)'
    fi

    code="$config_home/Code/User/settings.json"
    code_insiders="$config_home/Code - Insiders/User/settings.json"
    diff <(jq --sort-keys . "$code") <(jq --sort-keys . "$code_insiders")

    diff -i <(code --list-extensions) <(code-insiders --list-extensions)
}

# setup snappcloud proxy which is useful in the snapp datacenters
function snappcloud-proxy-on() {
    proxy_start internal-proxy.snapp.tech:8118
}

# remove snappcloud proxy which is useful in the snapp datacenters
function snappcloud-proxy-off() {
    proxy_stop
}

# report status of the current system public ip address
function ip-status() {
    # curl -s "https://api.ipquery.io/?format=json" | jq
    curl -s "https://api.ipapi.is" | jq
}

# report current country status
function country-status() {
    if type countryfetch >/dev/null 2>&1; then
        rm ~/.cache/countryfetch.json || true
        countryfetch
    fi
}

function gotz() {
    date
    echo "----"
    TZ="US/Eastern" date
    echo "----"
    TZ="US/Central" date
    echo "----"
    TZ="US/Mountain" date
    echo "----"
    TZ="US/Pacific" date
}

function setup_python_project() {
    # Define colors
    local GREEN='\033[0;32m'
    local YELLOW='\033[0;33m'
    local BLUE='\033[0;34m'
    local RED='\033[0;31m'
    local NC='\033[0m' # No Color

    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE} Python Project Setup with pyenv and venv${NC}"
    echo -e "${BLUE}========================================${NC}"

    # Check for pyenv installation
    if ! command -v pyenv &>/dev/null; then
        echo -e "${RED}Error: pyenv is not installed. Please install pyenv first.${NC}"
        echo -e "${YELLOW}Refer to https://github.com/pyenv/pyenv#installation for instructions.${NC}"
        return 1
    fi

    if [ -f '.python-version' ]; then
        echo -e "${RED}Error: .python-version does not exist.${NC}"
        return 1
    fi

    pyenv install -s

    echo -e "${GREEN}Local Python version set to $(pyenv version | cut -d ' ' -f 1).${NC}"

    echo -e "${BLUE}Creating virtual environment...${NC}"
    if [ ! -d '.venv' ]; then
        if ! pyenv exec python -mvenv .venv; then
            echo -e "${RED}Error: Failed to create virtual environment. Aborting.${NC}"
            return 1
        else
            echo -e "${GREEN}Virtual environment '.venv' created.${NC}"
        fi
    fi

    echo -e "${BLUE}Activating virtual environment...${NC}"
    # shellcheck disable=1091
    if ! source .venv/bin/activate; then
        echo -e "${RED}Error: Failed to activate virtual environment. Please activate it manually: source .venv/bin/activate${NC}"
        echo -e "${YELLOW}Project setup complete, but virtual environment activation failed.${NC}"
        echo -e "${GREEN}To activate: source .venv/bin/activate${NC}"
        return 0 # Still consider it partially successful
    fi
    echo -e "${GREEN}Virtual environment activated.${NC}"

    echo -e "${BLUE}You are now inside the virtual environment.${NC}"
    echo -e "${BLUE}To deactivate, run: deactivate${NC}"
    echo -e "${BLUE}To reactivate later: source .venv/bin/activate${NC}"
    echo -e "${GREEN}Python project '$(basename)' setup complete!${NC}"
    echo -e "${BLUE}========================================${NC}"
}
