# Archinstall

[`archinstall`](https://github.com/archlinux/archinstall) is a guided/automated ArchLinux installer.
This repository contains scripts and configuration that I use with `archinstall` to setup ArchLinux on desktop or
server.
For desktop, I prefer sway but I have scripts for hyperland too.

## How to

- Boot from [ArchLinux ISO](https://archlinux.org/download/)

- Install `git`

```bash
pacman -Sy archinstall git
```

- Clone dotfiles repository:

```bash
git clone https://github.com/1995parham/dotfiles
cd dotfiles/archinstall
```

- Partitioning using `fstab`. (please remember to create boot partition with _EFI System_ label).
  You can also skip this step and then do it in `archinstall` tui.

- Create Filesystems using e.g. `mkfs.fat -F32`, `mkfs.btrfs`. Again you can skip this step and then do it in `archinstall`
  TUI.

- Enable NTP. It is a required step because incorrect time may cause issue with HTTPS.

```bash
datetimectl set-ntp true
```

- Ignite the installation. It first shows the an interactive menu in which you can setup the disk layout, disk
  encryption, user(s) and hostname ([read
  more](https://archinstall.readthedocs.io/installing/guided.html#guided-installation)).

```bash
archinstall --config desktop.json # Desktop installation
archinstall --config server.json # Server installation
```

## Notes

### BTRFS Sub-Volumes

BTRFS sub-volumes are awesome and you can use the following layout (comming from Ubuntu):

| Name        | Mountpoint            |
| ----------- | --------------------- |
| @           | /                     |
| @home       | /home                 |
| @log        | /var/log              |
| @pkg        | /var/cache/pacman/pkg |
| @.snapshots | /.snapshots           |

Please note that, you need to set the wipe flag of the BTRFS partition to true for sub-volume creation to work.

### Encrypting an entire system

In release _2023.04.01_ disk encryption ([read more](https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system#LUKS_on_a_partition)
leads to invalid boot configuration and you need to mount root
directory manually in `initramfs` e.g.:

```bash
cryptsetup open /dev/sda2 root
mount /dev/mapper/root /mnt
```

For fixing it you must change the loader configuration in `/boot/loader/entries/` as follows:

- The encrypted disk PARTUUID is correct so you may not changing it or you can replace it
  with your partition UUID (e.g. `lsblk -dno UUID /dev/nvme0n1p2`)

- The root disk PARTUUID is not correct (this is the actual problem) and you need to replace
  it with your decrypted disk UUID (e.g. `lsblk -dno UUID /dev/mapper/luksdev`)
