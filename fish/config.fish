# --- environment (all sessions) ---

switch (uname)
    case Darwin
        # source brew's env natively (fish-correct syntax, no eval); support
        # both the Apple Silicon and Intel prefixes.
        for brew in /opt/homebrew/bin/brew /usr/local/bin/brew
            if test -x $brew
                $brew shellenv fish | source
                break
            end
        end
end

# keep PATH in sync with the zsh/bash setup; only add dirs that exist.
for dir in $HOME/bin $HOME/.local/bin $HOME/.cargo/bin $HOME/.pixi/bin
    test -d $dir; and fish_add_path $dir
end

set -gx DOTFILES_ROOT $(realpath "$(dirname (realpath ~/.config/fish/config.fish ))/..")

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

    # abbreviations expand inline (visible + editable in history), the modern
    # fish idiom over aliases.
    abbr -a python python3
    abbr -a r 'exec fish'

    # prefer eza (a modern, colorful ls) when available; eza ships its own
    # colors so it does not need dircolors (see conf.d/dircolors.fish).
    if type -q eza
        abbr -a ls 'eza --group-directories-first'
        abbr -a l 'eza -la --group-directories-first --git'
        abbr -a ls-la 'eza -la --group-directories-first --git'
        abbr -a lt 'eza --tree --level=2 --group-directories-first'
    end

    # navi cheatsheet on Ctrl-H (matches the zsh/bash bindings). fish 4.x
    # named-key syntax instead of the deprecated \ch escape form.
    if type -q navi
        if test "$fish_key_bindings" = fish_default_key_bindings
            bind ctrl-h _navi_smart_replace
        else
            bind -M insert ctrl-h _navi_smart_replace
        end
    end
end
