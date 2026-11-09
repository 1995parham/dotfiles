# Arch Linux ARM on Lima

This directory runs an Arch Linux ARM (aarch64) virtual machine on an Apple Silicon Mac with [Lima](https://lima-vm.io), and installs these dotfiles in it. The VM has no graphical interface. Use it to test the `main_pacman` paths of the scripts, or to use Arch from the terminal.

## Layout

```
lima/
├── CLAUDE.md           # this file
├── requirements.txt    # Homebrew formulas for the macOS host (lima, qemu)
├── arch.yaml           # Lima template: base template:archlinux + QEMU + the fixes below
└── scripts/
    ├── common.sh       # shared settings and helpers, sourced by the other scripts
    ├── create.sh       # install the requirements, create and start the VM
    ├── upgrade.sh      # full system upgrade, reboot when the kernel changes
    ├── dotfiles.sh     # clone the dotfiles in the VM, run install.sh and start.sh scripts
    └── up.sh           # create.sh + upgrade.sh + dotfiles.sh
```

`scripts/lima.sh` in the repository root is the `./start.sh lima` entry point. It installs `requirements.txt` with `require_brew` and then runs `lima/scripts/up.sh`. Do not copy the steps into `scripts/lima.sh`; change them here.

## Usage

Run the scripts from the macOS host. Each script takes the VM name as its first argument, the default is `arch` (or `$LIMA_VM`).

```bash
./start.sh lima                          # requirements + up.sh, through the phase engine
lima/scripts/up.sh                       # the same steps, without start.sh
lima/scripts/create.sh                   # only create and start the VM
lima/scripts/upgrade.sh                  # only upgrade
lima/scripts/dotfiles.sh arch env zsh    # run other start.sh scripts in the VM (default: env)
DOTFILES_REF=refs/heads/my-branch lima/scripts/dotfiles.sh   # test another ref of the host repo
limactl shell arch                       # open a shell in the VM
limactl stop arch && limactl delete arch # remove the VM
```

A new VM takes approximately 25 minutes: 1 minute to create, 20 minutes to upgrade (about 1 GB of packages from 2022 to now, with retries for hung downloads), and 3 minutes for the dotfiles with `env`.

## Requirements

- An Apple Silicon Mac (arm64). The VM is aarch64, so QEMU uses the `hvf` accelerator and the CPU speed is close to native. Disk, network and boot are slower.
- Homebrew, and the formulas in `requirements.txt`. `create.sh` installs the missing ones.
- Access to `*.mirror.archlinuxarm.org`. On a restricted network, send that domain through the tunnel.

## Why the template has these fixes

The `archlinux` template of Lima uses an old community aarch64 image (`mcginty/arch-boxes-arm`, March 2022, kernel 5.17). Each problem below happened on a real install, and `arch.yaml` or a script fixes it. Keep these fixes until the template uses a newer image.

| Problem | Symptom | Fix |
|---|---|---|
| The image does not boot with the `vz` driver | `vz driver state stopped`, empty `serial*.log` | `vmType: qemu` in `arch.yaml` |
| The network file matches only `Name=eth0`, and new systemd names the interface `enp0s*` | After the upgrade and reboot: `Failed to start Wait for Network to be Online`, `limactl start` waits 10 minutes, SSH gives `Connection reset by peer` | Provision writes `/etc/systemd/network/20-lima.network`, which matches by MAC address |
| `/boot` is a 200 MB FAT partition, and the new kernel package with all device trees needs about 170 MB | `error: Partition /boot too full` | Provision sets `NoExtract = boot/dtbs/* boot/Image.gz`, removes the fallback initramfs preset, and deletes the old files. The VM boots `Image` with UEFI from QEMU and does not need them |
| The space check of pacman ignores `NoExtract` | `/boot too full` also after the fix above | `upgrade.sh` disables `CheckSpace` during the upgrade and enables it again on exit |
| `os.archlinuxarm.org` redirects to a random regional mirror, and many give 502 or 403 | Slow or failed downloads | Provision writes a mirror list with `dk`, `hu`, `fr` first |
| With 5 parallel downloads, small `.sig` downloads hang through a tunnel | `Operation too slow. Less than 1 bytes/sec transferred` | Provision sets `ParallelDownloads = 2`, and the scripts retry pacman. Each try keeps its downloads in the cache |
| cloud-init 26 runs its stages through the new `cloud-init-main.service`, and the upgrade does not enable it | After the reboot: `nc: /run/cloud-init/share/final.sock: No such file or directory` in the journal, `/run/lima-ssh-ready` does not exist, `limactl start` fails with ``did not receive an event with the `running` status``. SSH works, but Lima's mounts and port forwards do not | `upgrade.sh` enables `cloud-init-main.service` before the reboot. The provision script cannot do it, because the provision script runs from Lima's boot script, which needs cloud-init |
| The upgrade changes D-Bus to `dbus-broker` while the system runs | `Job for dbus-broker.service failed`, pacman reports `command failed to execute correctly` | Not a real failure. `upgrade.sh` checks `pacman -Qu` instead of the exit code, and the reboot fixes the service |

The provision script in `arch.yaml` runs as root on each boot, so every step in it must be idempotent.

## Differences from x86_64 Arch

- The VM runs Arch Linux ARM, a separate project with its own repositories and mirrors. `/etc/os-release` has `ID=archarm` and `ID_LIKE=arch`.
- Some packages do not exist on aarch64. For example `reflector`, which `scripts/env.sh` skips when `ID=archarm`. When a `start.sh` script fails with `error: target not found: <pkg>`, check the package with `pacman -Si <pkg>` in the VM and skip it for `archarm` in the script.
- Many AUR `-bin` packages are x86_64 only. `yay` is not installed by these scripts, so `require_aur` fails unless the script sets `allow_no_aur=true` (`env.sh` does).

## Notes for changes

- `dotfiles.sh` clones the committed state of the host repository. Lima mounts the host home directory read-only at the same path, so the clone comes from `/Users/<user>/dotfiles` and the origin changes to the HTTPS URL of GitHub. Commit your changes first, or set `DOTFILES_REF` to a ref that holds them.
- The user in the VM is `<host user>.guest` (for example `nobitex.guest`), so no `main_<user>` function runs. Set `PROFILE` in the VM to use a profile.
- The login shell in the VM stays bash. Change it with `sudo chsh -s /usr/bin/zsh "$USER"`.
- The scripts here are plain bash, not `start.sh` modules. CI checks them with shellcheck (`-x`) and shfmt (4-space indent), the same as `scripts/`.
- Lima logs are in `~/.lima/<vm>/`: `serial.log` for the guest console, `ha.stderr.log` for the host agent.
