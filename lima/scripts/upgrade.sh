#!/usr/bin/env bash
# Do a full system upgrade in the VM, then reboot it if the kernel changed.
# Usage: lima/scripts/upgrade.sh [vm-name]
set -euo pipefail

# shellcheck source=lima/scripts/common.sh
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
lima_vm=${1:-${lima_vm}}

lima_running || lima_die "the VM is not running, run lima/scripts/create.sh first"

kernel_before=$(limactl shell --workdir / "${lima_vm}" -- uname -r)

lima_log 'upgrade the system'
# shellcheck disable=SC2119 # the script comes from stdin, it takes no arguments
lima_run <<'EOF'
set -euo pipefail

# pacman stops on a hung download. Each try keeps its downloads in the cache,
# so the next try continues from there.
retry() {
    local i
    for i in 1 2 3 4 5 6; do
        "$@" && return 0
        echo "try ${i} failed: $*" >&2
    done
    return 1
}

# The space check of pacman ignores NoExtract, so it counts the device trees
# that pacman does not install, and refuses the kernel upgrade. Disable the
# check for this upgrade only.
restore() { sudo sed -i 's/^#CheckSpace/CheckSpace/' /etc/pacman.conf; }
trap restore EXIT
sudo sed -i 's/^CheckSpace/#CheckSpace/' /etc/pacman.conf

retry sudo pacman -Sy --noconfirm --needed archlinux-keyring archlinuxarm-keyring

# A post-install hook can fail (for example dbus-broker, which cannot start
# while the old D-Bus daemon runs), so pacman's exit code is not reliable.
# The upgrade is complete when no package is out of date.
upgraded=false
for i in 1 2 3 4 5 6; do
    sudo pacman -Su --noconfirm || true
    if ! pacman -Qu >/dev/null; then
        echo 'the system is up to date'
        upgraded=true
        break
    fi
    echo "try ${i}: packages are still out of date" >&2
done
[ "${upgraded}" = true ] || exit 1

# cloud-init 26 runs all of its stages through the new cloud-init-main.service,
# and the upgrade does not enable it. Without it no stage runs, Lima's boot
# script does not run, and limactl start waits 10 minutes and fails.
if systemctl cat cloud-init-main.service >/dev/null 2>&1; then
    sudo systemctl enable cloud-init-main.service
fi
EOF

kernel_installed=$(limactl shell --workdir / "${lima_vm}" -- pacman -Q linux-aarch64 | awk '{print $2}')
if [[ "${kernel_before}" != "${kernel_installed}"* ]]; then
    lima_log "the kernel changed (${kernel_before} -> ${kernel_installed}), reboot the VM"
    limactl stop "${lima_vm}"
    limactl start --tty=false "${lima_vm}"
fi

lima_log "running kernel: $(limactl shell --workdir / "${lima_vm}" -- uname -r)"
