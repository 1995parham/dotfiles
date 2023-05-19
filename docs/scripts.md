# Scripts

These are applications that I use in a daily manner, so I created the following document about their usage
and the way of installation.

## Package Managers

The following operating systems and their package managers are supported:

- ArchLinux:
  - [Pacman](https://archlinux.org/pacman/)
  - [Yet another Yogurt](https://github.com/Jguer/yay)
- OSx
  - [Brew](https://brew.sh)

## Applications

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
|        MP3 Tags        | strawberry (pacman)               | Strawberry                                | iTunes         |
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
