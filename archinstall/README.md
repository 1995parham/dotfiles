# Archinstall

Install Archlinux with sway, server or hyprland profile using `archinstall` helper.
First, you need to enable internet connection using `iwctl` or `nmcli` then you can continue.

## How to

- clone this repository

```bash
pacman -Sy archinstall git
git clone https://github.com/1995parham/dotfiles
cd dotfiles/archinstall
```

- Partitioning using `fstab`. (please remember to create boot partition with _EFI System_ label).

- File system with `mkfs.fat -F32`, `mkfs.btrfs`

- Enable ntp

```bash
datetimectl set-ntp true
```

- Ignite

```bash
archinstall --config config.json
```
