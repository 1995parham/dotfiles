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

function ls --description 'List contents of directory'
    command ls -G $argv
end

# Setting PATH for Python 3.12
# The original version is saved in /Users/elahe/.config/fish/config.fish.pysave
set -x PATH "/Library/Frameworks/Python.framework/Versions/3.12/bin" "$PATH"
