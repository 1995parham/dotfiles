if status is-interactive
    # Commands to run in interactive sessions can go here
end

switch (uname)
    case Darwin
      eval "$(/opt/homebrew/bin/brew shellenv)"
end

starship init fish | source

fish_add_path $HOME/bin
fish_add_path $HOME/.local/bin

alias python="python3"

set -x DOTFILES_ROOT $(realpath "$(dirname (realpath ~/.config/fish/config.fish ))/..")

function _navi_smart_replace
  set -l current_process (commandline -p | string trim)

  if test -z "$current_process"
      commandline -i (navi --print)
  else
      set -l best_match (navi --print --best-match --query "$current_process")

      if not test "$best_match" >/dev/null
          return
      end

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

if type -q navi
  if test $fish_key_bindings = fish_default_key_bindings
      bind \ch _navi_smart_replace
  else
      bind -M insert \ch _navi_smart_replace
  end
end

# using fish in neovim terminal mode.
# neovim defines $NVIM in terminal mode and based on it
# we can detect we are running inside neovim and use nvr
# instead of neovim, etc.
if test -n "$NVIM"
    alias nvim=nvr
    set -gx EDITOR "nvr -cc split --bufdelete --remote-wait"
    set -gx MANPAGER "nvr -c 'Man!' -o -"
end
