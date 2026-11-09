#!/usr/bin/env bash
# Clone the dotfiles in the VM and run install.sh and the env script.
# Usage: lima/scripts/dotfiles.sh [vm-name] [start.sh script...]
#
# The clone comes from the committed state of the dotfiles repository on the
# host (Lima mounts the host home directory read-only). Uncommitted changes are
# not in the VM.
set -euo pipefail

# shellcheck source=lima/scripts/common.sh
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
lima_vm=${1:-${lima_vm}}
shift || true

# The scripts to run with ./start.sh -y. The default is the same as CI.
scripts=("$@")
[ "${#scripts[@]}" -gt 0 ] || scripts=(env)

# The ref of the host repository to install. Set it to test changes that are
# not on main, for example DOTFILES_REF=refs/heads/my-branch.
ref=${DOTFILES_REF:-main}

# The VM has no SSH key for GitHub, so use HTTPS for origin.
origin=$(git -C "${dotfiles_dir}" remote get-url origin | sed -E 's#^git@github.com:#https://github.com/#')

lima_running || lima_die "the VM is not running, run lima/scripts/create.sh first"

lima_log "install the dotfiles from ${dotfiles_dir} (${ref}), then run: ${scripts[*]}"
lima_run "${dotfiles_dir}" "${origin}" "${ref}" "${scripts[@]}" <<'EOF'
set -euo pipefail
host_repo=$1
origin=$2
ref=$3
shift 3

retry() {
    local i
    for i in 1 2 3 4 5 6; do
        "$@" && return 0
        echo "try ${i} failed: $*" >&2
    done
    return 1
}

# install.sh needs bash, zsh, tmux and vim. base-devel is for makepkg and yay.
retry sudo pacman -S --noconfirm --needed git zsh tmux vim base-devel

[ -d ~/dotfiles/.git ] || git clone "${host_repo}" ~/dotfiles
git -C ~/dotfiles fetch --quiet "${host_repo}" "${ref}"
if [ "${ref}" = main ]; then
    git -C ~/dotfiles checkout --quiet main
    git -C ~/dotfiles merge --ff-only FETCH_HEAD
else
    git -C ~/dotfiles checkout --quiet --detach FETCH_HEAD
fi
git -C ~/dotfiles remote set-url origin "${origin}"

cd ~/dotfiles
./install.sh -y

for script in "$@"; do
    # The start.sh scripts install packages with pacman, which can stop on a
    # hung download. Run again until it passes.
    retry ./start.sh -y "${script}"
done
EOF

lima_log "done, open a shell with: limactl shell ${lima_vm}"
