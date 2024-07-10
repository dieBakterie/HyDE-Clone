###### *<div align="right"><sub>// design by t2</sub></div>*
<div align = center>
    <a href="https://discord.gg/AYbJ9MJez7">
<img alt="Dynamic JSON Badge" src="https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscordapp.com%2Fapi%2Finvites%2FmT5YqjaJFh%3Fwith_counts%3Dtrue&query=%24.approximate_member_count&suffix=%20members&style=for-the-badge&logo=discord&logoSize=auto&label=The%20HyDe%20Project&labelColor=ebbcba&color=c79bf0">
    </a>
</div>

<!--
<img alt="Dynamic JSON Badge" src="https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscordapp.com%2Fapi%2Finvites%2FmT5YqjaJFh%3Fwith_counts%3Dtrue&query=%24.approximate_member_count&suffix=%20members&style=for-the-badge&logo=discord&logoSize=auto&label=The%20HyDe%20Project&labelColor=ebbcba&color=c79bf0">

<img alt="Dynamic JSON Badge" src="https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscordapp.com%2Fapi%2Finvites%2FmT5YqjaJFh%3Fwith_counts%3Dtrue&query=%24.approximate_presence_count&suffix=%20online&style=for-the-badge&logo=discord&logoSize=auto&label=The%20HyDe%20Project&labelColor=ebbcba&color=c79bf0">
-->

<div align="center">

![hyde_banner](https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/hyde_banner.png)

<br>

<a href="#installation"><kbd> <br> Installation <br> </kbd></a>&ensp;&ensp;
<a href="#themes"><kbd> <br> Themes <br> </kbd></a>&ensp;&ensp;
<a href="#styles"><kbd> <br> Styles <br> </kbd></a>&ensp;&ensp;
<a href="#keybindings"><kbd> <br> Keybindings <br> </kbd></a>&ensp;&ensp;
<a href="https://www.youtube.com/watch?v=2rWqdKU1vu8&list=PLt8rU_ebLsc5yEHUVsAQTqokIBMtx3RFY&index=1"><kbd> <br> Youtube <br> </kbd></a>&ensp;&ensp;
<a href="https://github.com/prasanthrangan/hyprdots/wiki"><kbd> <br> Wiki <br> </kbd></a>&ensp;&ensp;
<a href="https://discord.gg/qWehcFJxPa"><kbd> <br> Discord <br> </kbd></a>

</div><br><br>

https://github.com/prasanthrangan/hyprdots/assets/106020512/7f8fadc8-e293-4482-a851-e9c6464f5265

<br><div align="center"><img width="12%" src="https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/arch.png"/><br></div>

## Installation

The installation script is designed for a minimal [Arch Linux](https://wiki.archlinux.org/title/Arch_Linux) install, but **may** work on some [Arch-based distros](https://wiki.archlinux.org/title/Arch-based_distributions).
While installing HyDE alongside another [DE](https://wiki.archlinux.org/title/Desktop_environment)/[WM](https://wiki.archlinux.org/title/Window_manager) should work, due to it being a heavily customized setup, it **will** conflict with your [GTK](https://wiki.archlinux.org/title/GTK)/[Qt](https://wiki.archlinux.org/title/Qt) theming, [Shell](https://wiki.archlinux.org/title/Command-line_shell), [SDDM](https://wiki.archlinux.org/title/SDDM), [GRUB](https://wiki.archlinux.org/title/GRUB), etc. and is at your own risk.

> [!IMPORTANT]
> The install script will auto-detect an NVIDIA card and install nvidia-dkms drivers for your kernel.
> Please ensure that your NVIDIA card supports dkms drivers in the list provided [here](https://wiki.archlinux.org/title/NVIDIA).

> [!CAUTION]
> The script modifies your `grub` or `systemd-boot` config to enable NVIDIA DRM.

To install, execute the following commands:

```shell
pacman -Sy git
git clone --depth 1 https://github.com/dieBakterie/HyDE-Clone ~/HyDE-Clone
cd ~/HyDE-Clone/Scripts
./install.sh
```

> [!TIP]
> You can also add any other apps you wish to install alongside HyDE to `Scripts/custom_apps.lst` and pass the file as a parameter to install it like so:
>
> ```shell
> ./install.sh custom_apps.lst
> ```

[!CAUTION]
As a second install option, you can also use `Hyde-install`, which might be easier for some.
View installation instructions for HyDE in [Hyde-cli - Usage](https://github.com/kRHYME7/Hyde-cli?tab=readme-ov-file#usage).

Please reboot after the install script completes and takes you to the SDDM login screen (or black screen) for the first time.
For more details, please refer to the [installation wiki](https://github.com/prasanthrangan/hyprdots/wiki/Installation).

### Updating

To update HyDE, you will need to pull the latest changes from GitHub and restore the configs by running the following commands:

```shell
cd ~/HyDE-Clone/Scripts
git pull
./install.sh -r
```

> [!IMPORTANT]
> Please note that any configurations you made will be overwritten if listed to be done so as listed by `Scripts/restore_cfg.lst`.
> However, all replaced configs are backed up and may be recovered from in `~/.config/cfg_backups`.

As a second update option, you can use `Hyde restore ...`, which does have a better way of managing restore and backup options.
For more details, you can refer to [Hyde-cli - dots management wiki](https://github.com/kRHYME7/Hyde-cli/wiki/Dots-Management).

<div align="right">
  <br>
  <a href="#-design-by-t2"><kbd> <br> 🡅 <br> </kbd></a>
</div>

## Themes

All our official themes are stored in a separate repository, allowing users to install them using themepatcher.
For more information, visit [prasanthrangan/hyde-themes](https://github.com/prasanthrangan/hyde-themes).

<div align="center">
  <table><tr><td>

[![Catppuccin-Latte](https://placehold.co/130x30/dd7878/eff1f5?text=Catppuccin-Latte&font=Oswald)](https://github.com/prasanthrangan/hyde-themes/tree/Catppuccin-Latte)
[![Catppuccin-Mocha](https://placehold.co/130x30/b4befe/11111b?text=Catppuccin-Mocha&font=Oswald)](https://github.com/prasanthrangan/hyde-themes/tree/Catppuccin-Mocha)
[![Decay-Green](https://placehold.co/130x30/90ceaa/151720?text=Decay-Green&font=Oswald)](https://github.com/prasanthrangan/hyde-themes/tree/Decay-Green)
[![Edge-Runner](https://placehold.co/130x30/fada16/000000?text=Edge-Runner&font=Oswald)](https://github.com/prasanthrangan/hyde-themes/tree/Edge-Runner)
[![Frosted-Glass](https://placehold.co/130x30/7ed6ff/1e4c84?text=Frosted-Glass&font=Oswald)](https://github.com/prasanthrangan/hyde-themes/tree/Frosted-Glass)
[![Graphite-Mono](https://placehold.co/130x30/a6a6a6/262626?text=Graphite-Mono&font=Oswald)](https://github.com/prasanthrangan/hyde-themes/tree/Graphite-Mono)
[![Gruvbox-Retro](https://placehold.co/130x30/475437/B5CC97?text=Gruvbox-Retro&font=Oswald)](https://github.com/prasanthrangan/hyde-themes/tree/Gruvbox-Retro)
[![Material-Sakura](https://placehold.co/130x30/f2e9e1/b4637a?text=Material-Sakura&font=Oswald)](https://github.com/prasanthrangan/hyde-themes/tree/Material-Sakura)
[![Nordic-Blue](https://placehold.co/130x30/D9D9D9/476A84?text=Nordic-Blue&font=Oswald)](https://github.com/prasanthrangan/hyde-themes/tree/Nordic-Blue)
[![Rosé-Pine](https://placehold.co/130x30/c4a7e7/191724?text=Rosé-Pine&font=Oswald)](https://github.com/prasanthrangan/hyde-themes/tree/Rose-Pine)
[![Synth-Wave](https://placehold.co/130x30/495495/ff7edb?text=Synth-Wave&font=Oswald)](https://github.com/prasanthrangan/hyde-themes/tree/Synth-Wave)
[![Tokyo-Night](https://placehold.co/130x30/7aa2f7/24283b?text=Tokyo-Night&font=Oswald)](https://github.com/prasanthrangan/hyde-themes/tree/Tokyo-Night)

  </td></tr></table>
</div>

> [!TIP]
> Everyone, including you can create, maintain, and share additional themes, all of which can be installed using themepatcher!
> To create your own custom theme, please refer to the [theming wiki](https://github.com/prasanthrangan/hyprdots/wiki/Theming).
> If you wish to have your hyde theme showcased, or you want to find some non-official themes, visit [kRHYME7/hyde-gallery](https://github.com/kRHYME7/hyde-gallery)!

<div align="right">
  <br>
  <a href="#-design-by-t2"><kbd> <br> 🡅 <br> </kbd></a>
</div>

## Styles

<div align="center"><table><tr>Theme Select</tr><tr><td>
<img src="https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/theme_select_1.png"/></td><td>
<img src="https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/theme_select_2.png"/></td></tr></table></div>

<div align="center"><table><tr><td>Wallpaper Select</td><td>Launcher Select</td></tr><tr><td>
<img src="https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/walls_select.png"/></td><td>
<img src="https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/rofi_style_sel.png"/></td></tr>
<tr><td>Wallbash Modes</td><td>Notification Action</td></tr><tr><td>
<img src="https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/wb_mode_sel.png"/></td><td>
<img src="https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/notif_action_sel.png"/></td></tr>
</table></div>

<div align="center"><table><tr>Rofi Launcher</tr><tr><td>
<img src="https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/rofi_style_1.png"/></td><td>
<img src="https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/rofi_style_2.png"/></td><td>
<img src="https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/rofi_style_3.png"/></td></tr><tr><td>
<img src="https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/rofi_style_4.png"/></td><td>
<img src="https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/rofi_style_5.png"/></td><td>
<img src="https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/rofi_style_6.png"/></td></tr><tr><td>
<img src="https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/rofi_style_7.png"/></td><td>
<img src="https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/rofi_style_8.png"/></td><td>
<img src="https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/rofi_style_9.png"/></td></tr><tr><td>
<img src="https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/rofi_style_10.png"/></td><td>
<img src="https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/rofi_style_11.png"/></td><td>
<img src="https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/rofi_style_12.png"/></td></tr>
</table></div>

<div align="center"><table><tr>Wlogout Menu</tr><tr><td>
<img src="https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/wlog_style_1.png"/></td><td>
<img src="https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/wlog_style_2.png"/></td></tr></table></div>

<div align="center"><table><tr>Game Launcher</tr><tr><td>
<img src="https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/game_launch_1.png"/></td><td>
<img src="https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/game_launch_2.png"/></td><td>
<img src="https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/game_launch_3.png"/></td></tr></table></div>
<div align="center"><table><tr><td>
<img src="https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/game_launch_4.png"/></td><td>
<img src="https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/game_launch_5.png"/></td></tr></table></div>

<div align="right">
  <br>
  <a href="#-design-by-t2"><kbd> <br> 🡅 <br> </kbd></a>
</div>

## Keybindings

<div align="center">

<!--
| Keys | Action |
| :--- | :--- |
| <kbd>Super</kbd> + <kbd>Q</kbd><br><kbd>Alt</kbd> + <kbd>F4</kbd> | Close focused window |
| <kbd>Super</kbd> + <kbd>Del</kbd> | Kill Hyprland session |
| <kbd>Super</kbd> + <kbd>W</kbd> | Toggle the window between focus and float |
| <kbd>Super</kbd> + <kbd>G</kbd> | Toggle the window between focus and group |
| <kbd>Alt</kbd> + <kbd>Enter</kbd> | Toggle the window between focus and fullscreen |
| <kbd>Super</kbd> + <kbd>L</kbd> | Launch lock screen |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>F</kbd> | Toggle pin on focused window |
| <kbd>Super</kbd> + <kbd>Backspace</kbd> | Launch logout menu |
| <kbd>Ctrl</kbd> + <kbd>Esc</kbd> | Toggle waybar |
| <kbd>Super</kbd> + <kbd>T</kbd> | Launch terminal emulator (kitty) |
| <kbd>Super</kbd> + <kbd>E</kbd> | Launch file manager (dolphin) |
| <kbd>Super</kbd> + <kbd>C</kbd> | Launch text editor (vscode) |
| <kbd>Super</kbd> + <kbd>F</kbd> | Launch web browser (firefox) |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>Esc</kbd> | Launch system monitor (htop/btop or fallback to top) |
| <kbd>Super</kbd> + <kbd>A</kbd> | Launch application launcher (rofi) |
| <kbd>Super</kbd> + <kbd>Tab</kbd> | Launch window switcher (rofi) |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>E</kbd> | Launch file explorer (rofi) |
| <kbd>F10</kbd> | Toggle audio mute |
| <kbd>F11</kbd> | Decrease volume |
| <kbd>F12</kbd> | Increase volume |
| <kbd>Super</kbd> + <kbd>P</kbd> | Partial screenshot capture |
| <kbd>Super</kbd> + <kbd>Ctrl</kbd> + <kbd>P</kbd> | Partial screenshot capture (frozen screen) |
| <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>P</kbd> | Monitor screenshot capture |
| <kbd>PrtScn</kbd> | All monitors screenshot capture |
| <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>G</kbd> | Disable hypr effects for gamemode |
| <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>→</kbd><kbd>←</kbd> | Cycle wallpaper |
| <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>↑</kbd><kbd>↓</kbd> | Cycle waybar mode |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>R</kbd> | Launch wallbash mode select menu (rofi) |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>T</kbd> | Launch theme select menu (rofi) |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>A</kbd> | Launch style select menu (rofi) |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>W</kbd> | Launch wallpaper select menu (rofi) |
| <kbd>Super</kbd> + <kbd>V</kbd> | Launch clipboard (rofi) |
| <kbd>Super</kbd> + <kbd>K</kbd> | Switch keyboard layout |
| <kbd>Super</kbd> + <kbd>←</kbd><kbd>→</kbd><kbd>↑</kbd><kbd>↓</kbd> | Move window focus |
| <kbd>Alt</kbd> + <kbd>Tab</kbd> | Change window focus |
| <kbd>Super</kbd> + <kbd>[0-9]</kbd> | Switch workspaces |
| <kbd>Super</kbd> + <kbd>Ctrl</kbd> + <kbd>←</kbd><kbd>→</kbd> | Switch workspaces to a relative workspace |
| <kbd>Super</kbd> + <kbd>Ctrl</kbd> + <kbd>↓</kbd> | Move to the first empty workspace |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>←</kbd><kbd>→</kbd><kbd>↑</kbd><kbd>↓</kbd> | Resize windows |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>[0-9]</kbd> | Move focused window to a relative workspace |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>Ctrl</kbd> + <kbd>←</kbd><kbd>→</kbd><kbd>↑</kbd><kbd>↓</kbd> | Move focused window around the current workspace |
| <kbd>Super</kbd> + <kbd>MouseScroll</kbd> | Scroll through existing workspaces |
| <kbd>Super</kbd> + <kbd>LeftClick</kbd><br><kbd>Super</kbd> + <kbd>Z</kbd> | Move focused window |
| <kbd>Super</kbd> + <kbd>RightClick</kbd><br><kbd>Super</kbd> + <kbd>X</kbd> | Resize focused window |
| <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>S</kbd> | Move/Switch to special workspace (scratchpad) |
| <kbd>Super</kbd> + <kbd>S</kbd> | Toggle to special workspace |
| <kbd>Super</kbd> + <kbd>J</kbd> | Toggle focused window split |
| <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>[0-9]</kbd> | Move focused window to a workspace silently |
| <kbd>Super</kbd> + <kbd>Ctrl</kbd> + <kbd>H</kbd> | Move between grouped windows backward |
| <kbd>Super</kbd> + <kbd>Ctrl</kbd> + <kbd>L</kbd> | Move between grouped windows forward |
-->

| Keybind | Dispatcher | Command | Comments |
|---------|------------|---------|----------|
| <kbd>$mainMod Q</kbd> | exec | `$scrPath/dontkillsteam.sh` | close focused window |
| <kbd>Alt F4</kbd> | exec | `$scrPath/dontkillsteam.sh` | close focused window |
| <kbd>$mainMod Delete</kbd> | exit |  | kill hyprland session |
| <kbd>$mainMod W</kbd> | togglefloating |  | toggle the window between focus and float |
| <kbd>$mainMod G</kbd> | togglegroup |  | toggle the window between focus and group |
| <kbd>Alt Return</kbd> | fullscreen |  | toggle the window between focus and fullscreen |
| <kbd>$mainMod L</kbd> | exec | `$scrPath/screenlock.sh -m` | launch lock screen with mpris thumbnail (hyprlock) |
| <kbd>$mainMod+Shift F</kbd> | exec | `$scrPath/windowpin.sh` | toggle pin on focused window |
| <kbd>$mainMod Backspace</kbd> | exec | `$scrPath/logoutlaunch.sh` | launch logout menu |
| <kbd>Ctrl+Alt W</kbd> | exec | `killall waybar \|\| waybar` | toggle waybar |
| <kbd>$mainMod T</kbd> | exec | `$term` | launch terminal emulator |
| <kbd>$mainMod E</kbd> | exec | `$file` | launch file manager |
| <kbd>$mainMod C</kbd> | exec | `$editor` | launch text editor |
| <kbd>$mainMod F</kbd> | exec | `$browser` | launch web browser |
| <kbd>$mainMod N</kbd> | exec | `swaync-client -sw -t` | toggle notification center |
| <kbd>$mainMod+Alt V</kbd> | exec | `vesktop` | launch Vesktop |
| <kbd>Ctrl+Alt+Shift R</kbd> | pass | `^(com\.obsproject\.Studio)$` | toggle obs screen recording |
| <kbd>$mainMod Period</kbd> | exec | `emote` | launch emoji selector |
| <kbd>Ctrl+Shift Escape</kbd> | exec | `$scrPath/sysmonlaunch.sh` | launch system monitor (htop/btop or fallback to top) |
| <kbd>$mainMod K</kbd> | exec | `pkill -xf 'python /usr/lib/python3.12/site-packages/pyqtws/main.py -a google-calendar' \|\| silo -a google-calendar` | toggle Google Calendar silo |
| <kbd>$mainMod+Alt D</kbd> | exec | `pkill -xf 'python /usr/lib/python3.12/site-packages/pyqtws/main.py -a google-documents' \|\| silo -a google-documents` | toggle Google Documents silo |
| <kbd>$mainMod D</kbd> | exec | `pkill -xf 'python /usr/lib/python3.12/site-packages/pyqtws/main.py -a google-drive' \|\| silo -a google-drive` | toggle Google Drive silo |
| <kbd>$mainMod G</kbd> | exec | `pkill -xf 'python /usr/lib/python3.12/site-packages/pyqtws/main.py -a gmail' \|\| silo -a gmail` | toggle G-Mail silo |
| <kbd>$mainMod+Shift K</kbd> | exec | `pkill -xf 'python /usr/lib/python3.12/site-packages/pyqtws/main.py -a google-keep' \|\| silo -a google-keep` | toggle Google Keep silo |
| <kbd>$mainMod M</kbd> | exec | `pkill -xf 'python /usr/lib/python3.12/site-packages/pyqtws/main.py -a google-maps' \|\| silo -a google-maps` | toggle Google Maps silo |
| <kbd>$mainMod+Alt F</kbd> | exec | `pkill -xf 'python /usr/lib/python3.12/site-packages/pyqtws/main.py -a google-photos' \|\| silo -a google-photos` | toggle Google Photos silo |
| <kbd>$mainMod+Ctrl S</kbd> | exec | `pkill -xf 'python /usr/lib/python3.12/site-packages/pyqtws/main.py -a google-sheets' \|\| silo -a google-sheets` | toggle Google Sheets silo |
| <kbd>$mainMod+Shift S</kbd> | exec | `pkill -xf 'python /usr/lib/python3.12/site-packages/pyqtws/main.py -a google-slides' \|\| silo -a google-slides` | toggle Google Slides silo |
| <kbd>$mainMod+Alt W</kbd> | exec | `pkill -xf 'python /usr/lib/python3.12/site-packages/pyqtws/main.py -a WhatsApp' \|\| silo -a WhatsApp` | toggle WhatsApp-Web silo |
| <kbd>$mainMod O</kbd> | exec | `pkill -xf 'python /usr/lib/python3.12/site-packages/pyqtws/main.py -a Office365' \|\| silo -a Office365` | toggle Microsoft Office365 silo |
| <kbd>$mainMod+Ctrl T</kbd> | exec | `pkill -xf 'python /usr/lib/python3.12/site-packages/pyqtws/main.py -a Teams' \|\| silo -a Teams` | toggle Microsoft Teams silo |
| <kbd>$mainMod+Shift N</kbd> | exec | `pkill -xf 'python /usr/lib/python3.12/site-packages/pyqtws/main.py -a Netflix' \|\| silo -a Netflix` | toggle Netflix silo |
| <kbd>$mainMod+Shift P</kbd> | exec | `pkill -xf 'python /usr/lib/python3.12/site-packages/pyqtws/main.py -a PrimeVideo' \|\| silo -a PrimeVideo` | toggle Amazon PrimeVideo silo |
| <kbd>$mainMod+Alt T</kbd> | exec | `pkill -xf 'python /usr/lib/python3.12/site-packages/pyqtws/main.py -a Twitch' \|\| silo -a Twitch` | toggle Twitch silo |
| <kbd>$mainMod+Shift Y</kbd> | exec | `pkill -xf 'python /usr/lib/python3.12/site-packages/pyqtws/main.py -a YouTube' \|\| silo -a YouTube` | toggle YouTube silo |
| <kbd>$mainMod+Shift V</kbd> | exec | `pypr toggle volume && hyprctl dispatch bringactivetotop` | toggle volume scratchpad |
| <kbd>$mainMod B</kbd> | exec | `pypr toggle bluetooth && hyprctl dispatch bringactivetotop` | toggle bluetooth scratchpad |
| <kbd>$mainMod Y</kbd> | exec | `pypr toggle youtube-music && hyprctl dispatch bringactivetotop` | toggle YouTube Music scratchpad |
| <kbd>$mainMod+Shift E</kbd> | exec | `pypr toggle yazi && hyprctl dispatch bringactivetotop` | toggle yazi scratchpad |
| <kbd>$mainMod A</kbd> | exec | `pkill -x rofi \|\| $scrPath/rofilaunch.sh d` | launch application launcher |
| <kbd>$mainMod Tab</kbd> | exec | `pkill -x rofi \|\| $scrPath/rofilaunch.sh w` | launch window switcher |
| <kbd>$mainMod+Shift E</kbd> | exec | `pkill -x rofi \|\| $scrPath/rofilaunch.sh f` | launch file explorer |
| <kbd>XF86AudioMute</kbd> | exec | `$scrPath/volumecontrol.sh -o m` | toggle audio mute |
| <kbd>XF86AudioMicMute</kbd> | exec | `$scrPath/volumecontrol.sh -i m` | toggle microphone mute |
| <kbd>XF86AudioLowerVolume</kbd> | exec | `$scrPath/volumecontrol.sh -o d` | decrease volume |
| <kbd>XF86AudioRaiseVolume</kbd> | exec | `$scrPath/volumecontrol.sh -o i` | increase volume |
| <kbd>XF86AudioPlay</kbd> | exec | `playerctl play-pause` | toggle between media play and pause |
| <kbd>XF86AudioPause</kbd> | exec | `playerctl play-pause` | toggle between media play and pause |
| <kbd>XF86AudioNext</kbd> | exec | `playerctl next` | next media |
| <kbd>XF86AudioPrev</kbd> | exec | `playerctl previous` | previous media |
| <kbd>XF86MonBrightnessUp</kbd> | exec | `$scrPath/brightnesscontrol.sh i` | increase brightness |
| <kbd>XF86MonBrightnessDown</kbd> | exec | `$scrPath/brightnesscontrol.sh d` | decrease brightness |
| <kbd>$mainMod+Ctrl H</kbd> | changegroupactive | `b` | switch active group forward |
| <kbd>$mainMod+Ctrl L</kbd> | changegroupactive | `f` | switch active group backward |
| <kbd>$mainMod P</kbd> | exec | `$scrPath/screenshot.sh s` | partial screenshot capture |
| <kbd>$mainMod+Ctrl P</kbd> | exec | `$scrPath/screenshot.sh sf` | partial screenshot capture (frozen screen) |
| <kbd>$mainMod+Alt P</kbd> | exec | `$scrPath/screenshot.sh m` | monitor screenshot capture |
| <kbd>Print</kbd> | exec | `$scrPath/screenshot.sh p` | all monitors screenshot capture |
| <kbd>$mainMod+Alt G</kbd> | exec | `$scrPath/gamemode.sh` | disable hypr effects for gamemode |
| <kbd>$mainMod+Shift G</kbd> | exec | `pkill -x rofi \|\| $scrPath/gamelauncher.sh` | launch Steam game launcher |
| <kbd>$mainMod+Alt →</kbd> | exec | `$scrPath/swwwallpaper.sh -n` | next Wallpaper |
| <kbd>$mainMod+Alt ←</kbd> | exec | `$scrPath/swwwallpaper.sh -p` | previous Wallpaper |
| <kbd>$mainMod+Alt ↑</kbd> | exec | `$scrPath/wbarconfgen.sh n` | next Waybar mode |
| <kbd>$mainMod+Alt ↓</kbd> | exec | `$scrPath/wbarconfgen.sh p` | previous Waybar mode |
| <kbd>$mainMod+Shift R</kbd> | exec | `pkill -x rofi \|\| $scrPath/wallbashtoggle.sh -m` | launch wallbash mode select menu |
| <kbd>$mainMod+Shift T</kbd> | exec | `pkill -x rofi \|\| $scrPath/themeselect.sh` | launch theme select menu |
| <kbd>$mainMod+Shift A</kbd> | exec | `pkill -x rofi \|\| $scrPath/rofiselect.sh` | launch style select menu |
| <kbd>$mainMod+Shift W</kbd> | exec | `pkill -x rofi \|\| $scrPath/swwwallselect.sh` | launch wallpaper select menu |
| <kbd>$mainMod V</kbd> | exec | `pkill -x rofi \|\| $scrPath/cliphist.sh c` | launch clipboard |
| <kbd>$mainMod K</kbd> | exec | `$scrPath/keyboardswitch.sh` | switch keyboard layout |
| <kbd>$mainMod ?</kbd> | exec | `$scrPath/keybinds_hint.sh` | show keybind hints |
| <kbd>$mainMod ←</kbd> | movefocus | `l` | move focus to the left |
| <kbd>$mainMod →</kbd> | movefocus | `r` | move focus to the right |
| <kbd>$mainMod ↑</kbd> | movefocus | `u` | move focus up |
| <kbd>$mainMod ↓</kbd> | movefocus | `d` | move focus down |
| <kbd>Alt Tab</kbd> | movefocus | `d` | move focus down |
| <kbd>$mainMod 1</kbd> | workspace | `1` | switch to Workspace 1 |
| <kbd>$mainMod 2</kbd> | workspace | `2` | switch to Workspace 2 |
| <kbd>$mainMod 3</kbd> | workspace | `3` | switch to Workspace 3 |
| <kbd>$mainMod 4</kbd> | workspace | `4` | switch to Workspace 4 |
| <kbd>$mainMod 5</kbd> | workspace | `5` | switch to Workspace 5 |
| <kbd>$mainMod 6</kbd> | workspace | `6` | switch to Workspace 6 |
| <kbd>$mainMod 7</kbd> | workspace | `7` | switch to Workspace 7 |
| <kbd>$mainMod 8</kbd> | workspace | `8` | switch to Workspace 8 |
| <kbd>$mainMod+Ctrl →</kbd> | workspace | `r+1` | switch to next relative Workspace |
| <kbd>$mainMod+Ctrl ←</kbd> | workspace | `r-1` | switch to previous relative Workspace |
| <kbd>$mainMod+Ctrl ↓</kbd> | workspace | `empty` | move to the first empty Workspace |
| <kbd>$mainMod+Shift →</kbd> | resizeactive | `30 0` | expand active floating Window to the right |
| <kbd>$mainMod+Shift ←</kbd> | resizeactive | `-30 0` | shrink active floating Window to the left |
| <kbd>$mainMod+Shift ↑</kbd> | resizeactive | `0 -30` | shrink active floating Window down |
| <kbd>$mainMod+Shift ↓</kbd> | resizeactive | `0 30` | expand active floating Window up |
| <kbd>$mainMod+Shift 1</kbd> | movetoworkspace | `1` | move focused Window to Workspace 1 |
| <kbd>$mainMod+Shift 2</kbd> | movetoworkspace | `2` | move focused Window to Workspace 2 |
| <kbd>$mainMod+Shift 3</kbd> | movetoworkspace | `3` | move focused Window to Workspace 3 |
| <kbd>$mainMod+Shift 4</kbd> | movetoworkspace | `4` | move focused Window to Workspace 4 |
| <kbd>$mainMod+Shift 5</kbd> | movetoworkspace | `5` | move focused Window to Workspace 5 |
| <kbd>$mainMod+Shift 6</kbd> | movetoworkspace | `6` | move focused Window to Workspace 6 |
| <kbd>$mainMod+Shift 7</kbd> | movetoworkspace | `7` | move focused Window to Workspace 7 |
| <kbd>$mainMod+Shift 8</kbd> | movetoworkspace | `8` | move focused Window to Workspace 8 |
| <kbd>$mainMod+Ctrl+Alt →</kbd> | movetoworkspace | `r+1` | move focused window to the next relative Workspace |
| <kbd>$mainMod+Ctrl+Alt ←</kbd> | movetoworkspace | `r-1` | move focused window to the previous relative Workspace |
| <kbd>$mainMod+Shift+Ctrl ←</kbd> | movewindow | `l` | move focused Window to the left |
| <kbd>$mainMod+Shift+Ctrl →</kbd> | movewindow | `r` | move focused window to the right |
| <kbd>$mainMod+Shift+Ctrl ↑</kbd> | movewindow | `u` | move focused Window up |
| <kbd>$mainMod+Shift+Ctrl ↓</kbd> | movewindow | `d` | move focused Window down |
| <kbd>$mainMod 󱕑</kbd> | workspace | `e+1` | switch to the next Workspace |
| <kbd>$mainMod 󱕐</kbd> | workspace | `e-1` | switch to the previous Workspace |
| <kbd>$mainMod 󰍽</kbd> | movewindow |  | use Mouse to move focused Window |
| <kbd>$mainMod 󰍽</kbd> | resizewindow |  | use Mouse to resize focused Window |
| <kbd>$mainMod+Alt S</kbd> | movetoworkspacesilent | special | silently move window to Workspace special |
| <kbd>$mainMod S</kbd> | togglespecialworkspace |  | toggle Workspace special |
| <kbd>$mainMod J</kbd> | togglesplit |  | toggle split |
| <kbd>$mainMod+Alt 1</kbd> | movetoworkspacesilent | `1` | silently move focused Window to Workspace 1 |
| <kbd>$mainMod+Alt 2</kbd> | movetoworkspacesilent | `2` | silently move focused Window to Workspace 2 |
| <kbd>$mainMod+Alt 3</kbd> | movetoworkspacesilent | `3` | silently move focused Window to Workspace 3 |
| <kbd>$mainMod+Alt 4</kbd> | movetoworkspacesilent | `4` | silently move focused Window to Workspace 4 |
| <kbd>$mainMod+Alt 5</kbd> | movetoworkspacesilent | `5` | silently move focused Window to Workspace 5 |
| <kbd>$mainMod+Alt 6</kbd> | movetoworkspacesilent | `6` | silently move focused Window to Workspace 6 |
| <kbd>$mainMod+Alt 7</kbd> | movetoworkspacesilent | `7` | silently move focused Window to Workspace 7 |
| <kbd>$mainMod+Alt 8</kbd> | movetoworkspacesilent | `8` | silently move focused Window to Workspace 8 |

</div>

<div align="right">
  <br>
  <a href="#-design-by-t2"><kbd> <br> 🡅 <br> </kbd></a>
</div>
