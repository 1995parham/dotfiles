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

![Compatibility](https://img.shields.io/badge/works%20on-macos-white?logo=macos&style=for-the-badge)
![Compatibility](https://img.shields.io/badge/works%20on-ubuntu-orange?logo=ubuntu&style=for-the-badge)
![Compatibility](https://img.shields.io/badge/works%20on-arch-blue?logo=archlinux&style=for-the-badge)

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
- [...](./docs/scripts.md)

You can install them by running the following script:

```bash
./start.sh <name>
```

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

## More

- [archinstall](./archinstall/README.md)
