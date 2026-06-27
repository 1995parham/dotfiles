# Load dircolors for a colorful GNU ls (mirrors the bash/zsh setup).
# Only needed on the GNU-ls fallback path; eza (see config.fish) brings
# its own colors and ignores this.
# dircolors emits POSIX-sh syntax that fish can't eval, so we use the
# csh form (-c -> `setenv LS_COLORS '...'`) and extract the value.
if not type -q eza; and type -q dircolors; and test -f "$HOME/.dircolors"
    set -gx LS_COLORS (dircolors -c "$HOME/.dircolors" | string replace -r "^setenv LS_COLORS '(.*)'\$" '$1')
end
