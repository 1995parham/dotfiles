#!/usr/bin/env bash
set -euo pipefail

echo "[post-install] Custom steps placeholder (runs inside installed system)"

# Example: add your host-specific setup below, e.g.:
pacman -Syu --noconfirm
# systemctl enable --now sshd.service

echo "[post-install] Done"
