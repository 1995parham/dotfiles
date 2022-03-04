# Archinstall

Install arch (i3) with `archinstall` helper. first of all you need to enable internet connection using `iwctl` or `nmcli` then you can continue.

## How to

- clone this repository

```sh
pacman -Sy archinstall git
git clone https://github.com/1995parham/dotfiles
cd dotfiles/archinstall
```

- partioning using `fstab`. (please remeber to create boot partion with _EFI System_ label.

- file system with `mkfs.fat -F32`, `mkfs.btrfs`

- enable ntp

```sh
datetimectl set-ntp true
```

- ignite

```sh
archinstall --config i3.json
```
