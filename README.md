# My MangoWM Dotfiles for Arch Linux

This repository contains modular dotfiles for [Mango](https://github.com/DreamMaoMao/mangowc)  Wayland compositor on Arch Linux. 
Mango is a tiling window manager based on DWL with a focus on keyboard-driven workflows and dynamic layouts (_This Setup focuses mainly on ``scrolling layout``_). Configurations are managed using [GNU Stow](https://www.gnu.org/software/stow/) for easy symlinking to `~/.config/`. _**Assumes a fresh install of Arch**_

<!-- <img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/254875ee-cb75-408d-99e1-f44ba4819ece" /> -->

https://github.com/user-attachments/assets/f7d1ca9a-4fa1-46aa-b81f-ca7849aab6cf


## Quick Setup for New System

Run the complete setup script via curl on a fresh Arch install (e.g., after `archinstall`).

- **What It Does** _step-by-step_:
  1. Updates system `sudo pacman -Syu`.
  2. Installs prerequisites (git, stow, base-devel).
  7. Backs up existing `~/.config` (to `~/.config.backup`).
  3. Clones this repo to `~/Mango-arch-dotfiles`.
  5. Installs AUR helpers `paru` & `yay` if missing.
  6. Installs packages (see list below).
  8. Stows all configs (e.g., `niri/`, `fish/`, `waybar/`).
  9. Installs Ly Display Manager (optional)

- **Security Note**: Review the script source from the repo before running. It requires sudo, internet, and assumes a minimal Arch base. For safety, download manually:
### One-Liner Installation (Requires Curl)
```bash
curl -fsSL https://raw.githubusercontent.com/fyiimysf/Mango-arch-dotfiles/main/setup.sh | bash
```
*OR*
### Cloning the repo:
```bash
git clone --depth=1 https://github.com/fyiimysf/Mango-arch-dotfiles.git
cd ~/Mango-arch-dotfiles
chmod +x setup.sh
./setup.sh
```
### Optional:
- **Only Stow**: Only to stow to `~/.config`:
```bash
cp -r ~/.config ~/.config.backup
git clone --depth=1 https://github.com/fyiimysf/Mango-arch-dotfiles.git
cd ~/Mango-arch-dotfiles
chmod +x stow.sh
./stow.sh
```


## Packages Installed

The script installs the following via pacman (official repos) and paru (AUR). These support MangoWM, shells, editing, and Wayland essentials:

### Official (pacman):
- Core: `git`, `stow`, `nvim`, `curl`, `brightnessctl`, `x11`, `wlroots`, `wayland`
- Shell/Terminal: `fish`, `foot`, `wezterm`, `alacritty`, `kitty`
- Wayland/UI: `mango` (compositor), `swaync` (notifications), `swayidle` (idle), `waybar` (bar), `wlogout` (logout), `fuzzel` (launcher),  `rofi` (launcher), `cliphist` (clipboard), `wlsunset` (night light), `waypaper` (wallpaper manager), `swww` (wallpaper package)
- Utilities: `fastfetch` (info), `nemo` (file manager), `gdu` (disk), `yazi` (terminal FM), `gnome-calculator`, `librewolf` (browser)

### AUR (paru):
- `avizo` (notifications), `xwayland-satellite` (XWayland compat), `tuned` (tuning), `hyprlock` (locker), `hyprpicker` (picker), `grim` (screenshots), `slurp` (screenshot utility)

**Notes**:
- ~37 packages total; AUR builds may take 5-15 minutes (needs RAM/disk space).
- If AUR fails (e.g., dependencies), run `paru -Syu` and retry manually.
- Mango-specific: Mango Focused WM setup.
- Ly DM: Installs and Enables Ly as the Display Manager of choice (optional)
## Post-Installation

1. **Change Shell**: `chsh -s /usr/bin/fish` (logs you out).
2. **Mango Setup**:
   - Edit `~/.config/mango/config.conf` for keybinds (e.g., mod=Super, workspaces via numbers).
   - Enable Mango session in your display manager (e.g., Ly: select "Mango" at login).
3. **Neovim**: `nvim +Lazy sync` (assumes Lazy.nvim; adjust for your plugin manager).
4. **Wayland Tools**:
   - Start Waybar: Add to Mango config or run `waybar &`.
   - Clipboard: Add `cliphist watch` to startup (e.g., via Mango exec-once).
   - Notifications: `swaync-client -o` to test.
   - Screenshots: Bind `grim` in Mango config.
5. **Reboot/Log Out**: Start Mango session. Verify: `ls -la ~/.config | grep -E "(mango|waybar|fish|nvim)"`.
6. **Customization**: Test selectively—unstow with `stow -D <package>` if issues.

## Updates & Maintenance

From `~/Mango-arch-dotfiles`:
```bash
git pull
cd stow
stow -Rv -t '../../' */  # Restow changes
```
- For package updates: `sudo pacman -Syu; paru -Syu`.
- Troubleshooting:
  - Stow conflicts: Use dry-run (`stow -n -v <package>`).
  - Mango Issues: Check `journalctl -b -u ly`.
  - Permissions: `chown -R $USER:$USER ~/dotfiles`.

## Directory Structure

```
dotfiles/
├── README.md                 # This file
├── setup.sh                  # Full setup script (curlable)
├── mango/                    # Mango config (config.conf, autostart.sh)
├── fish/                     # Fish shell (config.fish)
├── nvim/                     # Neovim (init.lua)
├── waybar/                   # Waybar (config.json, style.css)
├── wezterm/                  # Wezterm (wezterm.lua)
├── swaync/                   # Notifications
├── fuzzel/                   # Launcher
├── wlsunset/                 # Night light    
├── ...                       # Other: alacritty, kitty, etc.
└── LICENSE
```

## Contributing

Fork and PR modular changes (e.g., new Mango keybinds). Test on Arch with Mango.

## License

MIT License - see [LICENSE](LICENSE) for details.
