# --- environment (all sessions) ---

switch (uname)
    case Darwin
        # native fish output; no eval, and brew emits fish-correct syntax
        /opt/homebrew/bin/brew shellenv fish | source
end

fish_add_path $HOME/bin
fish_add_path $HOME/.local/bin

set -x DOTFILES_ROOT $(realpath "$(dirname (realpath ~/.config/fish/config.fish ))/..")

# navi smart-replace widget. define the function for every session; it is only
# *bound* to a key in interactive sessions below.
function _navi_smart_replace
    set -l current_process (commandline -p | string trim)

    if test -z "$current_process"
        commandline -i (navi --print)
    else
        set -l best_match (navi --print --best-match --query "$current_process")

        if test -z "$best_match"
            commandline -p (navi --print --query "$current_process")
        else if test "$current_process" != "$best_match"
            commandline -p $best_match
        else
            commandline -p (navi --print --query "$current_process")
        end
    end

    commandline -f repaint
end

# using fish in neovim terminal mode. neovim defines $NVIM in terminal mode and
# based on it we use nvr instead of a nested neovim, etc.
if test -n "$NVIM"
    alias nvim=nvr
    set -gx EDITOR "nvr -cc split --bufdelete --remote-wait"
    set -gx MANPAGER "nvr -c 'Man!' -o -"
end

# --- interactive-only setup ---

if status is-interactive
    starship init fish | source

    alias python="python3"

    # reload the shell (re-reads config.fish and conf.d/*)
    abbr -a r 'exec fish'

    # prefer eza (a modern, colorful ls) when available; eza ships its own
    # colors so it does not need dircolors (see conf.d/dircolors.fish).
    if type -q eza
        alias ls 'eza --group-directories-first'
        alias l 'eza -la --group-directories-first --git'
        alias ls-la 'eza -la --group-directories-first --git'
        alias lt 'eza --tree --level=2 --group-directories-first'
    end

    # navi cheatsheet on Ctrl-H (matches the zsh/bash bindings). uses the fish
    # 4.x named-key syntax instead of the deprecated \ch escape form.
    if type -q navi
        if test "$fish_key_bindings" = fish_default_key_bindings
            bind ctrl-h _navi_smart_replace
        else
            bind -M insert ctrl-h _navi_smart_replace
        end
    end
end
