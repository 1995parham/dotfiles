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

This repository contains Parham Alvani's personal `dotfiles` for configuring various tools in his development environment. These `dotfiles` are intended to be used on macOS and Linux systems.

A `dotfiles` repository is a personal repository, and with it, you can manage your configuration between your systems. So I made this repository a template repository, so you can easily start your personal one from it.

Special thanks to [@elahe-dastan](https://github.com/elahe-dastan/) for using this project and reporting its issues. Her unique contributions to this repository and my life are unforgettable.

## Installation

<p align="center">
    <img alt="Compatibility" src="https://img.shields.io/badge/works%20on-macos-white?logo=macos&style=for-the-badge">
    <img alt="Compatibility" src="https://img.shields.io/badge/works%20on-ubuntu-orange?logo=ubuntu&style=for-the-badge">
    <img alt="Compatibility" src="https://img.shields.io/badge/works%20on-arch-blue?logo=archlinux&style=for-the-badge">
</p>

You need to first install an operating system to use these `dotfiles`,
For installing [`ArchLinux`](https://archlinux.org/) from scratch, please check [here](./archinstall)

To install these `dotfiles` on a fresh system, run the following command:

```bash
git clone https://github.com/1995parham/dotfiles.git ~/.dotfiles && cd ~/.dotfiles && ./start.sh env && ./install.sh
```

This will clone the repository into your home directory (`~/.dotfiles`), and run the `start.sh env` script to install required tools and then run `install.sh` script to
create symbolic links between the `dotfiles` and their expected locations in your home directory.

After that, you set `zsh` as your default terminal:

```bash
sudo chsh $USER -s /bin/zsh
```

Run `start.sh font` script to install useful fonts:

```bash
./start.sh font
```

**Don't** forget setting the git username and email:

```bash
touch $HOME/.config/git/config
```

or you can use mine:

```bash
./start.sh git
```

Run `start.sh neovim` script to install neovim with [`ElieVIM`](https://github.com/1995parham/elievim) configurations:

```bash
./start.sh neovim
```

## Hosts

I have the following systems with [starship naming](https://namingschemes.com/Starships) as follows:

- [`pegasus`](<https://en.wikipedia.org/wiki/Pegasus_(Battlestar_Galactica)>): Lenovo Y9000K 2022 Gaming Laptop which is huge and always stays at home. Last `ArchLinux`
  installation happened on 06 Sep 2023 using `archlinux-2023.09.01-x86_64.iso`. ✅
- `x-wing`: Lenovo ThinkPad X13 Generation 3 Laptop is lightweight and always with me in travel.
  Last `ArchLinux` installation happened. 🚧
- `tie-fighter`: Asus Zephyrus G14 GA401Q Laptop is a gift from Queen, and it stays at Snapp!.
  Last `ArchLinux` installation happened on 31 Aug 2023 using `archlinux-2023.08.01-x86_64.iso`. 🚧

- `death-star`: Tower server based on ROG STRIX X399-E GAMING Motherboard. It's always home and ready for duties. ✅

## Usage

These `dotfiles` configure various tools and applications, including:

- `docker`
- `yt-dlp`
- `alacritty`
- etc.

You can install most of them by running the following script:

```bash
./start.sh <name>
```

### Package Managers

The following operating systems and their package managers are supported:

- `ArchLinux`:
  - [`pacman`](https://archlinux.org/pacman/)
  - [Yet another Yogurt (`yay`)](https://github.com/Jguer/yay)
- `OSx`
  - [`brew`](https://brew.sh)

### Applications

For each package, I provided information on its installation script and how to run it on different operating systems.
Applications with command names in all lowercase can be run from the command line interface, while those with title case need to be launched using your application launcher.
If an application is marked with a (?), it means I had a negative experience with that application on that particular operating system.

To find software compatible with sway, always check the [`are we wayland yet`](https://arewewaylandyet.com/) website.

|          Role          | How to Install?                   | ArchLinux                                 | OSx            |
| :--------------------: | :-------------------------------- | :---------------------------------------- | :------------- |
|        Anydesk         | `anydesk-bin (yay)`               | Anydesk                                   | -              |
|        Browser         | `./start.sh browser`              | Firefox, Firefox Developer Edition, etc.  | Firefox, etc.  |
|        Calendar        | `./start.sh env`                  | `cal`, `jcal`                             | -              |
|         Camera         | `guvcview (pacman)`               | `guvcview`                                | Photo Booth    |
|  cat clone with wings  | `./start.sh env`                  | `bat`                                     | `bat`          |
|         Fetch          | `./start.sh fetch`                | `neofetch`, `onefetch`, `tokei`           | `              |
|          BTop          | `./start.sh btop`                 | `btop`                                    | `              |
|    Container Engine    | `./start.sh docker`               | `docker`                                  | Docker Desktop |
|    Container Engine    | `./start.sh podman`               | `podman`                                  | `podman`       |
|    Desktop Manager     | `./archinstall/sway.sh`           | `greetd`, `greetd-tuigreet`               | -              |
|     Window Manager     | `./archinstall/sway.sh`           | `sway`                                    | -              |
|       Dictionary       | `./start.sh def`                  | `def`                                     | `def`          |
|    Download Manager    | `./start.sh env`                  | `aria2c`                                  | `aria2c`       |
|    Drawing Diagram     | `./start.sh drawio`               | `drawio`                                  | `drawio`       |
|         Emacs          | `./start.sh emacs`                | `emacs`                                   | `emacs` (?)    |
|   GNU Privacy Guard    | `./start.sh env`                  | `gpg`                                     | -              |
|     Habit Tracker      | `./start.sh dijo`                 | `dijo`                                    | -              |
|  HTTP/GRPC Load Test   | `./start.sh env`                  | `k6`                                      | `k6`           |
|      Image Editor      | `./start.sh image`                | GNU Image Manipulation Program, `convert` | Preview        |
|      Image Viewer      | `./start.sh sway`                 | `imv`                                     | Preview        |
| Terminal Image Viewer  | `./start.sh env`                  | `chafa`                                   | -              |
|        Launcher        | `./start.sh sway`                 | `rofi`                                    | -              |
|        MP3 Tags        | `./start.sh mpd`                  | Strawberry                                | iTunes         |
|      Music Player      | `./start.sh mpd`                  | `mpc`, `ncmpcpp`                          | -              |
|         neovim         | `./start.sh neovim`               | `nvim`                                    | `nvim`         |
|          vim           | `./start.sh env`                  | `vim`                                     | `vim`          |
|       Networking       | `NetworkManager (archinstall)`    | `nmtui`, `nmcli`                          | -              |
| Network Time Protocol  | `chrony (pacman)`                 | -                                         | -              |
|      Note Keeping      | `xournalpp (pacman)`              | Xournalpp                                 | Xournalpp      |
|      Office Suite      | `./start.sh office`               | LibreOffice                               | Office         |
|     Packet Sniffer     | `./start.sh wireshark`            | Wireshark                                 | -              |
|     Packet Sniffer     | `termshark (pacman)`              | `termshark`                               | -              |
|    Password Manager    | `./start.sh gopass`               | `gopass`                                  | `gopass`       |
|       PDF Viewer       | `./start.sh sway`                 | `mupdf`                                   | Preview        |
|     Power Manager      | -                                 | -                                         | -              |
|         Skype          | `skypeforlinux-preview-bin (yay)` | Skype Preview                             | Skype          |
|       Clipboard        | `./start.sh sway`                 | `wl-copy`, `wl-paste`                     | -              |
|     Wayland Evnets     | `wev (yay)`                       | `wev`                                     | -              |
|     Network Speed      | `./start.sh env`                  | `speedtest-cli`                           | -              |
|       Status Bar       | `./start.sh sway`                 | `waybar`                                  | -              |
|       Syncthing        | `./start.sh syncthing`            | `syncthing`                               | `syncthing`    |
|   Terminal Emulator    | `./start.sh alacritty`            | `alacritty`                               | Alacritty (?)  |
|   Terminal Emulator    | `./start.sh kitty`                | `kitty`                                   | Kitty          |
|   Terminal Emulator    | `./start.sh foot`                 | `foot`                                    | -              |
|  Terminal Multiplexer  | `./start.sh env`                  | `tmux`                                    | `tmux`         |
|      Video Editor      | `ffmpeg (pacman)`                 | `ffmpeg`                                  | `ffmpeg`       |
|      Video Player      | `./start.sh mpv`                  | `mpv`                                     | `mpv`          |
|       Wallpaper        | `./start.sh sway`                 | `wpaperd`                                 | -              |
|   Youtube Downloader   | `./start.sh yt-dlp`               | `yt-dlp`                                  | `yt-dlp`       |
|        Timezone        | `./start.sh gotz`                 | `gotz`                                    | -              |
|      Google Cloud      | `./start.sh gcloud`               | `gcloud`                                  | -              |
| Multi-OS Bootable Disk | `./start.sh ventoy`               | `ventoy`                                  | -              |
|  LaTex/XeTex/Texlive   | `./start.sh texlive`              | `tlmgr`, `xelatex`, `latexmk`, etc.       | -              |
|     Android, Quest     | `./start.sh android`              | `adb`, SideQuest                          | -              |
|    Bandwidth Usage     | `./start.sh env`                  | `bandwhich`                               | -              |
|          TLDR          | `./start.sh tealdeer`             | `tldr`                                    | -              |
|          DNS           | `./start.sh blocky`               | `blocky`                                  | -              |
|          JSON          | `./start.sh env`                  | `jq`, `jless`                             | -              |
|  Disk Usage Analyzer   | `./start.sh env`                  | `dua`                                     | `dua`          |

## [Window Managers](https://wiki.archlinux.org/title/Window_manager) (on ArchLinux)

I am using [`sway`](https://github.com/swaywm/) or [`hyprland`](https://github.com/hyprwm) as my primary window managers. This repository
structured around creating soft-links and because of that the duplicate configurations
between these window managers are gathered in `sway/`.

## [Emacs](https://www.gnu.org/software/emacs/)

I am using Emacs for the followings:

- latex documents (specially when writing them in Persian)
- org-mode (for managing my daily life)

### Searching

[Ivy](https://github.com/abo-abo/swiper) is a plugin for searching in buffers, notes, etc.
Almost everything in doom Emacs works with ivy. It is simple and will show you a popup for everything.

### Configuration (based on doom)

I use Emacs based on [doom](https://github.com/doomemacs), and I found following configurations are useful to update my configurations based on them.

1. [psamim dotfiles](https://github.com/github/psamim/dotfiles)
   - [My org-mode agenda, much better now with category icons!](https://www.reddit.com/r/emacs/comments/hnf3cw/my_orgmode_agenda_much_better_now_with_category/?utm_source=share&utm_medium=web2x&context=3)
2. [acdemic doom](https://github.com/sunnyhasija/Academic-Doom-Emacs-Config)
3. [elenapan dotfiles](https://github.com/elenapan/dotfiles)

### Workspace

Never close emacs, just use workspace to manage your work.
To work with workspace just start with `SPACE-TAB`.

## Windows as Virtual Machine

Windows has some softwares that you don't have on linux, software likes [JumpDesktop](https://jumpdesktop.com/), [Microsoft Office](https://www.office.com/), etc.
I need to use these softwares and because of that, I always install Windows using [KVM](https://www.redhat.com/en/topics/virtualization/what-is-KVM) on host machine.

### What we need to do after installation?

During installation you need to provide your outlook account and then you have up and running system in no time.
These are the software that I need on my system:

|         Name          | How to Install?                                        |
| :-------------------: | :----------------------------------------------------- |
| Microsoft office 2021 | [p30download](https://p30download.ir/fa/entry/101362/) |
|      JumpDesktop      | [JumpDesktop](https://jumpdesktop.com/)                |
|    Github Desktop     | `winget install 'github desktop'`                      |
|        VSCode         | `winget install vscode`                                |
|       Anaconda        | `winget install anaconda3`                             |
|   Adobe Acrobat Pro   | [p30download](https://p30download.ir/fa/entry/58302/)  |
|          Git          | `winget install Git.Git`                               |
|         Skype         | `winget install 'Skype Insiders'`                      |
