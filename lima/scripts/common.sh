#!/usr/bin/env bash
# Shared settings and helpers for the lima/scripts/*.sh scripts.
# Source this file, do not run it.

# The name of the VM. Override it with the first argument or with LIMA_VM.
lima_vm=${LIMA_VM:-arch}

# The lima/ directory and the dotfiles root, on the macOS host.
lima_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
# shellcheck disable=SC2034 # used by the scripts that source this file
dotfiles_dir=$(cd "${lima_dir}/.." && pwd)

lima_log() {
    printf '\033[1;36m[lima:%s]\033[0m %s\n' "${lima_vm}" "$*"
}

lima_die() {
    printf '\033[1;31m[lima:%s] error:\033[0m %s\n' "${lima_vm}" "$*" >&2
    exit 1
}

lima_exists() {
    limactl list --quiet 2>/dev/null | grep -qx "${lima_vm}"
}

lima_running() {
    [ "$(limactl list --format '{{.Status}}' "${lima_vm}" 2>/dev/null)" = "Running" ]
}

# Run a bash script (read from stdin) in the VM. Extra arguments go to the script.
lima_run() {
    limactl shell --workdir / "${lima_vm}" -- bash -s -- "$@"
}
