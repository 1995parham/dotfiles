<h1 align="center">1995parham's dotfiles</h1>

<p align="center">
     <img alt="GitHub" src="https://img.shields.io/github/license/1995parham/dotfiles?logo=gnu&style=for-the-badge">
     <img alt="GitHub Workflow Status" src="https://img.shields.io/github/actions/workflow/status/1995parham/dotfiles/install.yaml?logo=github&style=for-the-badge&label=install">
     <img alt="GitHub Workflow Status" src="https://img.shields.io/github/actions/workflow/status/1995parham/dotfiles/sh-lint.yaml?label=lint&logo=github&style=for-the-badge">
     <a href="https://github.com/1995parham-me/ansible-role">
          <img alt="Ansible" src="https://img.shields.io/badge/ansible-ready-black?logo=ansible&style=for-the-badge">
     </a>
     <img alt="GitHub repo size" src="https://img.shields.io/github/repo-size/1995parham/dotfiles?style=for-the-badge">
</p>

## Introduction

This repository contains Parham Alvani's personal dotfiles for configuring various tools in his development environment. These dotfiles are intended to be used on macOS and Linux systems.

A dotfiles repository is a personal repository, and with it, you can manage your configuration between your systems. So I made this repository a template repository, so you can easily start your personal one from it.

Special thanks to [@elahe-dastan](https://github.com/elahe-dastan/) for using this project and reporting its issues. Her unique contributions to this repository and my life are unforgettable.

## Installation

> For installing arch itself, please check [here](./archinstall)

<p align="center">
     <img alt="Compatibility" src="https://img.shields.io/badge/works%20on-macos-white?logo=macos&style=for-the-badge">
     <img alt="Compatibility" src="https://img.shields.io/badge/works%20on-ubuntu-orange?logo=ubuntu&style=for-the-badge">
     <img alt="Compatibility" src="https://img.shields.io/badge/works%20on-arch-blue?logo=archlinux&style=for-the-badge">
</p>

To install these dotfiles on a new system, run the following command:

```bash
git clone https://github.com/1995parham/dotfiles.git ~/.dotfiles && cd ~/.dotfiles && ./start.sh env && ./install.sh
```

This will clone the repository into your home directory (`~/.dotfiles`), and run the `start.sh env` script to install required tools and then run `install.sh` script to
to create symbolic links between the dotfiles and their expected locations in your home directory.

After that, you set `zsh` as your default terminal:

```
sudo chsh $USER -s /bin/zsh
```

Run `start.sh font` script to install useful fonts:

```bash
./start.sh font
```

**Don't** forget changing the git username and email:

```bash
touch $HOME/.config/git/config
```

Run `start.sh neovim` script to install neovim with [ElieVIM](https://github.com/1995parham/elievim) configurations:

```bash
./start.sh neovim
```

## Usage

These dotfiles configure various tools and applications, including:

- Docker
- yt-dlp
- Alacritty
- ...

You can install most of them by running the following script:

```bash
./start.sh <name>
```

- [Read More...](./docs/scripts.md)

## Window Managers

I am using [`sway`](https://github.com/swaywm/) and [`hyprland`](https://github.com/hyprwm) as my primary window managers. This repository
structured around creating soft-links and because of that the duplicate configurations
between these window managers are gathered in `sway/`.

## Emacs

I am using Emacs for the followings:

- latex documents (specially in Persian)
- org-mode

### Searching

Ivy is a plugin for searching in buffers, notes, etc.
Almost everything in doom Emacs works with ivy. It is simple and will show you a popup for everything.

### Configuration (based on doom)

I use Emacs based on doom, and I found following configurations are useful to update my configurations based on them.

1. [psamim dotfiles](https://github.com/github/psamim/dotfiles)
   - [My org-mode agenda, much better now with category icons!](https://www.reddit.com/r/emacs/comments/hnf3cw/my_orgmode_agenda_much_better_now_with_category/?utm_source=share&utm_medium=web2x&context=3)
2. [acdemic doom](https://github.com/sunnyhasija/Academic-Doom-Emacs-Config)
3. [elenapan dotfiles](https://github.com/elenapan/dotfiles)

### Workspace

Never close emacs, just use workspace to manage your work.
To work with workspace just start with _SPACE-TAB_.

## Scripts

These are applications that I use in a daily manner, so I created the following document about their usage
and the way of installation.

### Package Managers

The following operating systems and their package managers are supported:

- ArchLinux:
  - [Pacman](https://archlinux.org/pacman/)
  - [Yet another Yogurt](https://github.com/Jguer/yay)
- OSx
  - [Brew](https://brew.sh)

### Applications

For each package, I provided information on its installation script and how to run it on different operating systems.
Applications with command names in all lowercase can be run from the command line interface, while those with title case need to be launched using your application launcher.
If an application is marked with a (?), it means I had a negative experience with it on that particular operating system.

To find software compatible with sway, always check the [are we wayland yet](https://arewewaylandyet.com/) website.

|          Role          | How to Install?                   | Archlinux                                 | OSx            |
| :--------------------: | :-------------------------------- | :---------------------------------------- | :------------- |
|        Anydesk         | anydesk-bin (yay)                 | Anydesk                                   | -              |
|        Browser         | ./start.sh browser                | Firefox, Firefox Developer Edition        | Firefox        |
|        Calendar        | ./start.sh env                    | `cal`, `jcal`                             | -              |
|         Camera         | guvcview (pacman)                 | `guvcview`                                | Photo Booth    |
|  cat clone with wings  | ./start.sh env                    | `bat`                                     | `bat`          |
|         Fetch          | ./start.sh fetch                  | `neofetch`, `onefetch`, `tokei`           | `              |
|          BTop          | ./start.sh btop                   | `btop`                                    | `              |
|    Container Engine    | ./start.sh docker                 | `docker`                                  | Docker Desktop |
|    Container Engine    | ./start.sh podman                 | `podman`                                  | `podman`       |
|    Desktop Manager     | ./archinstall/sway.sh             | `greetd`, `greetd-tuigreet`               | -              |
|     Window Manager     | ./archinstall/sway.sh             | `sway`                                    | -              |
|       Dictionary       | ./start.sh def                    | `def`                                     | `def`          |
|    Download Manager    | ./start.sh env                    | `aria2c`                                  | `aria2c`       |
|    Drawing Diagram     | ./start.sh drawio                 | `drawio`                                  | `drawio`       |
|         Emacs          | ./start.sh emacs                  | `emacs`                                   | `emacs` (?)    |
|   GNU Privacy Guard    | ./start.sh env                    | `gpg`                                     | -              |
|     Habit Tracker      | ./start.sh dijo                   | `dijo`                                    | -              |
|  HTTP/gRPC Load Test   | ./start.sh env                    | `k6`                                      | `k6`           |
|      Image Editor      | ./start.sh image                  | GNU Image Manipulation Program, `convert` | Preview        |
|      Image Viewer      | ./start.sh sway                   | `imv`                                     | Preview        |
| Terminal Image Viewer  | ./start.sh env                    | `chafa`                                   | -              |
|        Launcher        | ./start.sh sway                   | `rofi`                                    | -              |
|        MP3 Tags        | ./start.sh mpd                    | Strawberry                                | iTunes         |
|      Music Player      | ./start.sh mpd                    | `mpc`, `ncmpcpp`                          | -              |
|         neovim         | ./start.sh neovim                 | `nvim`                                    | `nvim`         |
|          vim           | ./start.sh env                    | `vim`                                     | `vim`          |
|       Networking       | NetworkManager with `archinstall` | `nmtui`, `nmcli`                          | -              |
| Network Time Protocol  | chrony (pacman)                   | -                                         | -              |
|      Note Keeping      | xournalpp (pacman)                | Xournalpp                                 | Xournalpp      |
|      Office Suite      | ./start.sh office                 | LibreOffice                               | Office         |
|     Packet Sniffer     | ./start.sh wireshark              | Wireshark                                 | -              |
|     Packet Sniffer     | termshark (pacman)                | `termshark`                               | -              |
|    Password Manager    | ./start.sh gopass                 | `gopass`                                  | `gopass`       |
|       PDF Viewer       | ./start.sh sway                   | `mupdf`                                   | Preview        |
|     Power Manager      | -                                 | -                                         | -              |
|         Skype          | skypeforlinux-preview-bin (yay)   | Skype Preview                             | Skype          |
|       Clipboard        | ./start.sh sway                   | `wl-copy`, `wl-paste`                     | -              |
|     Wayland Evnets     | wev (yay)                         | `wev`                                     | -              |
|     Network Speed      | ./start.sh env                    | `speedtest-cli`                           | -              |
|       Status Bar       | ./start.sh sway                   | `waybar`                                  | -              |
|       Syncthing        | ./start.sh syncthing              | `syncthing`                               | `syncthing`    |
|   Terminal Emulator    | ./start.sh alacritty              | `alacritty`                               | Alacritty (?)  |
|   Terminal Emulator    | ./start.sh kitty                  | `kitty`                                   | Kitty          |
|   Terminal Emulator    | ./start.sh foot                   | `foot`                                    | -              |
|  Terminal Multiplexer  | ./start.sh env                    | `tmux`                                    | `tmux`         |
|      Video Editor      | ffmpeg (pacman)                   | `ffmpeg`                                  | `ffmpeg`       |
|      Video Player      | ./start.sh mpv                    | `mpv`                                     | `mpv`          |
|       Wallpaper        | ./start.sh sway                   | `wpaperd`                                 | -              |
|   Youtube Downloader   | ./start.sh yt-dlp                 | `yt-dlp`                                  | `yt-dlp`       |
|        Timezone        | ./start.sh gotz                   | `gotz`                                    | -              |
|      Google Cloud      | ./start.sh gcloud                 | `gcloud`                                  | -              |
| Multi-OS Bootable Disk | ./start.sh ventoy                 | `ventoy`                                  | -              |
|  LaTex/XeTex/Texlive   | ./start.sh texlive                | `tlmgr`, `xelatex`, `latexmk`, etc.       | -              |
|     Android, Quest     | ./start.sh android                | `adb`, SideQuest                          | -              |
|    Bandwidth Usage     | ./start.sh env                    | `bandwhich`                               | -              |
|          TLDR          | ./start.sh tealdeer               | `tldr`                                    | -              |
|          DNS           | ./start.sh blocky                 | `blocky`                                  | -              |
|          JSON          | ./start.sh env                    | `jq`, `jless`                             | -              |
|  Disk Usage Analyzer   | ./start.sh env                    | `dua`                                     | `dua`          |
