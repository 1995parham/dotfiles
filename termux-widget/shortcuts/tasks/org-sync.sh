#!/usr/bin/env bash

# https://stackoverflow.com/questions/3822621/how-to-exit-if-a-command-failed
set -eu
set -o pipefail

cd /sdcard/Notes/org
git pull origin main
git push origin main
