<h1 align="center">1995parham's dotfiles</h1>

<p align="center">
    <img alt="GitHub" src="https://img.shields.io/github/license/1995parham/dotfiles?logo=gnu&style=for-the-badge">
    <img alt="GitHub Workflow Status" src="https://img.shields.io/github/actions/workflow/status/1995parham/dotfiles/install.yaml?logo=github&style=for-the-badge&label=install">
    <img alt="GitHub Workflow Status" src="https://img.shields.io/github/actions/workflow/status/1995parham/dotfiles/sh-lint.yaml?label=lint&logo=github&style=for-the-badge">
    <a href="https://github.com/1995parham-me/ansible-role">
        <img alt="Ansible" src="https://img.shields.io/badge/ansible-ready-black?logo=ansible&style=for-the-badge">
    </a>
    <img alt="GitHub repo size" src="https://img.shields.io/github/repo-size/1995parham/dotfiles?style=for-the-badge">
    <img alt="GitHub Created At" src="https://img.shields.io/github/created-at/1995parham/dotfiles?style=for-the-badge&logo=github">
</p>

## Introduction

This repository houses Parham Alvani's personal `dotfiles`,
which serve as configuration files for various tools in his development and living environment.
These `dotfiles` are designed specifically for use on macOS and Linux systems, excluding Windows or WSL.

`Dotfiles` repositories are personal repositories that facilitate the management of configurations across different systems.
To make the process easier for others, I have made this repository a template that can be used as a starting point
for creating personal `dotfiles` repositories.
You can find more information about `dotfiles` and their significance [here](https://virgool.io/@rsharifnasab/dotfiles-emhmfto0nijw).

I would like to express my special thanks to [@elahe-dastan](https://github.com/elahe-dastan/) for not only utilizing this project
but also providing valuable feedback, particularly regarding macOS compatibility.
Her remarkable contributions to both this repository and my personal life are truly unforgettable.

## Installation

<p align="center">
    <img alt="Compatibility" src="https://img.shields.io/badge/works%20on-macos-white?logo=macos&style=for-the-badge">
    <img alt="Compatibility" src="https://img.shields.io/badge/works%20on-ubuntu-orange?logo=ubuntu&style=for-the-badge">
    <img alt="Compatibility" src="https://img.shields.io/badge/works%20on-arch-blue?logo=archlinux&style=for-the-badge">
</p>

You need to first install an operating system to use these `dotfiles`,
For installing [`ArchLinux`](https://archlinux.org/) from scratch with [`archinstall`](https://github.com/archlinux/archinstall/),
please check [here](./archinstall).

In the case of using macOS, you already have the installed macOS
(Use recovery mode by Press and hold the power button on your Mac until the system volume and the Options button
appear). During the fresh-installation, please check [here](./macos).
There is no need for installing the operating system, and you cannot customize anything about it.
Just run the following script to have the setup:

```bash
# install brew with the default configuration.
./start.sh brew
# configure osx with Parham's preferences.
./start.sh macos
```

To install these `dotfiles` on a fresh system, run the following command:

```bash
git clone https://github.com/1995parham/dotfiles.git ~/.dotfiles && cd ~/.dotfiles && ./start.sh env && ./install.sh
```

This will clone the repository into your home directory (`~/.dotfiles`), and run the `start.sh env` script to install
required tools and then run `install.sh` script to
create symbolic links between the `dotfiles` and their expected locations in your home directory.

After that, you can set `zsh` as your default terminal (you can use bash too, there is no hard requirement to use `zsh`):

```bash
sudo chsh $USER -s /bin/zsh
```

Run `start.sh font` script to install useful fonts (obviously on a desktop system):

```bash
./start.sh font
```

**Don't** forget to set the git username and email:

```bash
touch $HOME/.config/git/config
```

or you can use mine (it's crystal clear these values is useful only for **me** and my **queen**):

```bash
./start.sh git
```

Run `start.sh neovim` script to install `neovim` with [`ElieVIM`](https://github.com/1995parham/elievim) configurations:

```bash
./start.sh neovim
```

## Hosts (naming based on Star Wars and Battlestar Galactica movies)

Elahe and I have the following systems with [starship naming](https://namingschemes.com/Starships) as follows.
Here is the list of available resources to find name names using the schema.

- <https://en.wikipedia.org/wiki/List_of_fictional_spacecraft>

### Parham

- [`millennium-falcon`](https://en.wikipedia.org/wiki/Millennium_Falcon): After years I bought another MacBook
  to taste the Apple world again. Please note that the disk is encrypted and named `Falcon HD`.
  The last `macOS Ventura` installation happened on 15 Jun 2025. ✅

    |   Type    |                           Value                           |
    | :-------: | :-------------------------------------------------------: |
    |  System   |                   `Mac16,7 (MX2Y3LL/A)`                   |
    | Processor | `Apple M4 Pro 14 cores (10 performance and 4 efficiency)` |
    |  Memory   |                 `LPDDR5 - Hynix - 48 GB`                  |

    ![](<https://img.shields.io/badge/Apple-MacBook_Pro_(16--inch,_2024)-333333?style=for-the-badge&logo=apple&logoColor=white>)

- [`tantive-iv`](https://en.wikipedia.org/wiki/Tantive_IV): MacBook Air (14,2). The last `macOS Ventura` installation happened on 15 Jun 2025. ✅

    |   Type    |                        Value                        |
    | :-------: | :-------------------------------------------------: |
    |  System   |               `Mac15,12 (MXCR3LL/A)`                |
    | Processor | `Apple M3 8 cores (4 performance and 4 efficiency)` |
    |  Memory   |              `LPDDR5 - Hynix - 16 GB`               |

    ![](<https://img.shields.io/badge/Apple-MacBook_Air_(13--inch,_M2,_2022)-333333?style=for-the-badge&logo=apple&logoColor=white>)

- [`ghost`](https://starwars.fandom.com/wiki/Ghost) is my phone which is Samsung Galaxy S24 Ultra.

The username is always set to [`parham`](https://en.wikipedia.org/wiki/Parham).

### Elahe

- [`sandcrawler`](https://en.wikipedia.org/wiki/Sandcrawler): MacBook Pro (14,9) given by Digikala, and it should
  return to them when Elahe decide to leave. The last `macOS` installation happened on dawn of the time. 🗑️

    |   Type    |                          Value                           |
    | :-------: | :------------------------------------------------------: |
    |  System   |                  `Mac14,9 (MPHE3LL/A)`                   |
    | Processor | `Apple M2 Pro 10 cores (6 performance and 4 efficiency)` |
    |  Memory   |                `LPDDR5 - Micron - 16 GB`                 |

    ![](<https://img.shields.io/badge/Apple-MacBook_Pro_(14--inch,_2023)-333333?style=for-the-badge&logo=apple&logoColor=white>)

The username is always set to `elahe`.

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
- `macOS`
    - [`brew`](https://brew.sh)

### Applications

For each package, I provided information on its installation script and how to run it on different operating systems.
Applications with command names in all lowercase can be run from the command line interface, while those with title cases need to be launched using your application launcher.
If an application is marked with a (?), it means I had a negative experience with that application on that particular operating system.

To find software compatible with sway, always check the [`are we wayland yet`](https://arewewaylandyet.com/) website.

|          Role          | How to Install?           | ArchLinux                                 | macOS                            |
| :--------------------: | :------------------------ | :---------------------------------------- | :------------------------------- |
|        AnyDesk         | `anydesk-bin (yay)`       | AnyDesk                                   | -                                |
|        Browser         | `./start.sh browser`      | Google Chrome Beta                        | Google Chrome Beta               |
|        Calendar        | `./start.sh env`          | `cal`, `jcal`                             | `cal`, `jcal`                    |
|         Camera         | `guvcview (pacman)`       | `guvcview`                                | Photo Booth                      |
|  cat clone with wings  | `./start.sh env`          | `bat`                                     | `bat`                            |
|         Fetch          | `./start.sh fetch`        | `fastfetch`, `onefetch`, `tokei`          | `fastfetch`, `onefetch`, `tokei` |
|         `btop`         | `./start.sh btop`         | `btop`                                    | `btop`                           |
|    Container Engine    | `./start.sh docker`       | `docker`                                  | Docker                           |
|    Desktop Manager     | `./archinstall/i3.sh`     | `lightdm`                                 | -                                |
|     Window Manager     | `./archinstall/i3.sh`     | `i3`                                      | -                                |
|       Dictionary       | `./start.sh def`          | `def`                                     | `def`                            |
|    Download Manager    | `./start.sh env`          | `aria2c`                                  | `aria2c`                         |
|    Drawing Diagram     | `./start.sh drawio`       | `drawio`                                  | `drawio`                         |
|         Emacs          | `./start.sh emacs`        | `emacs`                                   | `emacs`                          |
|   GNU Privacy Guard    | `./start.sh gpg`          | `gpg`                                     | `gpg`                            |
|     Habit Tracker      | `./start.sh dijo`         | `dijo`                                    | `dijo`                           |
|  HTTP/GRPC Load Test   | `./start.sh env`          | `k6`                                      | `k6`                             |
|      Image Editor      | `./start.sh image`        | GNU Image Manipulation Program, `convert` | Preview                          |
|      Image Viewer      | `./start.sh i3`           | `imv`                                     | Preview                          |
| Terminal Image Viewer  | `./start.sh env`          | `chafa`                                   | `chafa`                          |
|        Launcher        | `./start.sh i3`           | `rofi`                                    | -                                |
|         neovim         | `./start.sh neovim`       | `nvim`                                    | `nvim`                           |
|          vim           | `./start.sh env`          | `vim`                                     | `vim`                            |
|       Networking       | `NetworkManager (pacman)` | `nmtui`, `nmcli`                          | -                                |
| Network Time Protocol  | `chrony (pacman)`         | -                                         | -                                |
|      Office Suite      | `./start.sh office`       | LibreOffice                               | Office                           |
|     Packet Sniffer     | `./start.sh wireshark`    | Wireshark                                 | -                                |
|     Packet Sniffer     | `termshark (pacman)`      | `termshark`                               | -                                |
|    Password Manager    | `./start.sh gopass`       | `gopass`                                  | `gopass`                         |
|       PDF Viewer       | `./start.sh i3`           | `mupdf`                                   | Preview                          |
|     Power Manager      | -                         | -                                         | -                                |
|         Skype          | `./start.sh skype`        | Skype Preview                             | Skype                            |
|       Clipboard        | `./start.sh i3`           | `xclip`                                   | `pbcopy`/`pbpaste`               |
|     Network Speed      | `./start.sh env`          | `speedtest`                               | `speedtest`                      |
|       Status Bar       | `./start.sh i3`           | `polybar`                                 | -                                |
|       Syncthing        | `./start.sh syncthing`    | `syncthing`                               | `syncthing`                      |
|   Terminal Emulator    | `./start.sh alacritty`    | `alacritty`                               | Alacritty (?)                    |
|   Terminal Emulator    | `./start.sh kitty`        | `kitty`                                   | Kitty                            |
|  Terminal Multiplexer  | `./start.sh env`          | `tmux`                                    | `tmux`                           |
|      Video Editor      | `./start.sh ffmpeg`       | `ffmpeg`                                  | `ffmpeg`                         |
|      Video Player      | `./start.sh mpv`          | `mpv`                                     | `mpv`                            |
|       Wallpaper        | `./start.sh i3`           | `feh`                                     | -                                |
|   YouTube Downloader   | `./start.sh yt-dlp`       | `yt-dlp`                                  | `yt-dlp`                         |
|        Timezone        | `./start.sh gotz`         | `gotz`                                    | -                                |
|      Google Cloud      | `./start.sh gcloud`       | `gcloud`                                  | -                                |
| Multi-OS Bootable Disk | `./start.sh ventoy`       | `ventoy`                                  | -                                |
|  LaTeX/XeTeX/TeXLive   | `./start.sh tex`          | `tectonic`                                | `tectonic`                       |
|    Bandwidth Usage     | `./start.sh env`          | `bandwhich`                               | -                                |
|          TLDR          | `./start.sh tealdeer`     | `tldr`                                    | `tldr`                           |
|          DNS           | `./start.sh blocky`       | `blocky`                                  | -                                |
|          JSON          | `./start.sh env`          | `jq`, `jless`                             | `jq`, `jless`                    |
|  Disk Usage Analyzer   | `./start.sh env`          | `dua`                                     | `dua`                            |

## [Window Managers](https://wiki.archlinux.org/title/Window_manager) (on ArchLinux)

I am using [`sway`](https://github.com/swaywm/) or [`hyprland`](https://github.com/hyprwm) as my primary window managers. This repository
structured around creating soft links and because of that the duplicate configurations
between these window-managers are gathered in `wayland/`.

I also, have configuration for [`i3`](https://i3wm.org/) and [`awesomewm`](https://awesomewm.org/) as x11 window managers.
The shared configuration of these two are placed in `x11` folder.

## [Emacs](https://www.gnu.org/software/emacs/)

I am using Emacs for the following:

- latex documents (especially when writing them in Persian)
- org-mode (for managing my daily life)

### Searching

[Ivy](https://github.com/abo-abo/swiper) is a plugin for searching in buffers, notes, etc.
Almost everything in Doom Emacs works with ivy. It is simple and will show you a popup for everything.

### Configuration (based on doom)

I use Emacs based on [doom](https://github.com/doomemacs), and I found the following configurations are useful to update my configurations based on them.

1. [psamim dotfiles](https://github.com/github/psamim/dotfiles)
    - [My org-mode agenda, much better now with category icons!](https://www.reddit.com/r/emacs/comments/hnf3cw/my_orgmode_agenda_much_better_now_with_category/?utm_source=share&utm_medium=web2x&context=3)
2. [Academic doom](https://github.com/sunnyhasija/Academic-Doom-Emacs-Config)
3. [elenapan dotfiles](https://github.com/elenapan/dotfiles)

### Workspace

Never close Emacs, just use workspace to manage your work.
To work with workspace just start with `SPACE-TAB`.

## Windows as Virtual Machine

Because there are software applications like [Microsoft Office](https://www.office.com/) that are only available on Windows,
I install Windows using [KVM](https://www.redhat.com/en/topics/virtualization/what-is-KVM)
or VMWare Fusion on my host machine to use them. Based on my naming schema, I named it `Rager`.

### What do we need to do after installation?

During installation, you need to provide your Outlook account, and then you have an up and running system in no time.
These are the software that I need on my system:

|         Name          | How to Install?                                        |
| :-------------------: | :----------------------------------------------------- |
| Microsoft Office 2021 | [p30download](https://p30download.ir/fa/entry/101362/) |
|    GitHub Desktop     | `winget install 'github desktop'`                      |
|  Visual Studio Code   | `winget install vscode`                                |
|       Anaconda        | `winget install anaconda3`                             |
|   Adobe Acrobat Pro   | [p30download](https://p30download.ir/fa/entry/58302/)  |
|          Git          | `winget install Git.Git`                               |
|         Skype         | `winget install 'Skype Insiders'`                      |

## References

- <https://github.com/Ruixi-rebirth/sway-dotfiles>
- <https://github.com/philiprein/macos-settings>
- Icons by [Icons8](https://icons8.com)
