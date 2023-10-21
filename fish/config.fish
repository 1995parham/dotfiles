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
