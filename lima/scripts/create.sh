#!/usr/bin/env bash
# Install the host requirements, then create and start the Arch Linux ARM VM.
# Usage: lima/scripts/create.sh [vm-name]
set -euo pipefail

# shellcheck source=lima/scripts/common.sh
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
lima_vm=${1:-${lima_vm}}

[[ "${OSTYPE}" == darwin* ]] || lima_die 'this setup is for macOS hosts'
command -v brew >/dev/null || lima_die 'Homebrew is not installed'

missing=()
while read -r formula; do
    [ -z "${formula}" ] && continue
    brew list --versions "${formula}" >/dev/null || missing+=("${formula}")
done < <(grep -vE '^\s*(#|$)' "${lima_dir}/requirements.txt")

if [ "${#missing[@]}" -gt 0 ]; then
    lima_log "install the host requirements: ${missing[*]}"
    brew install "${missing[@]}"
fi

if lima_running; then
    lima_log 'the VM is already running'
elif lima_exists; then
    lima_log 'start the VM'
    limactl start --tty=false "${lima_vm}"
else
    lima_log "create the VM from ${lima_dir}/arch.yaml"
    limactl start --tty=false --name="${lima_vm}" "${lima_dir}/arch.yaml"
fi

lima_log "ready, open a shell with: limactl shell ${lima_vm}"
