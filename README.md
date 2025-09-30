# My NiriWM Dotfiles for Arch Linux

This repository contains modular dotfiles for a [Niri](https://github.com/YaLTeR/niri) Wayland compositor setup on Arch Linux. Niri is a scrollable-tiling window manager with a focus on keyboard-driven workflows and dynamic layouts. Configurations are managed using [GNU Stow](https://www.gnu.org/software/stow/) for easy symlinking to `~/.config/`.
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/254875ee-cb75-408d-99e1-f44ba4819ece" />

## Quick Setup for New System

Run the complete setup script via curl on a fresh Arch install (e.g., after `archinstall`). It handles system update, cloning this repo, installing Paru (AUR helper), all required packages via pacman/paru, and stowing dotfiles.

### One-Liner Installation (Requires Curl)
```bash
curl -fsSL https://raw.githubusercontent.com/yourusername/dotfiles/main/setup-complete.sh | bash
```
- **Security Note**: Review the script source from the repo before running. It requires sudo, internet, and assumes a minimal Arch base. For safety, download manually: `curl -O https://raw.githubusercontent.com/.../setup-complete.sh; chmod +x setup-complete.sh; ./setup-complete.sh`.
- **What It Does**:
  1. Updates system (`sudo pacman -Syu`).
  2. Installs prerequisites (git, stow, base-devel).
  3. Clones this repo to `~/dotfiles`.
  4. Installs Paru if missing.
  5. Installs packages (see list below).
  6. Backs up existing `~/.config` (to `~/.config.backup`).
  7. Stows all configs (e.g., `niri/`, `fish/`, `waybar/`).

### If the repo is already cloned:
```bash
cd ~/dotfiles
./setup-complete.sh
```

## Packages Installed

The script installs the following via pacman (official repos) and paru (AUR). These support NiriWM, shells, editing, and Wayland essentials:

### Official (pacman):
- Core: `git`, `stow`, `nvim`, `curl`, `brightnessctl`
- Shell/Terminal: `fish`, `foot`, `wezterm`, `alacritty`, `kitty`
- Wayland/UI: `niri` (compositor), `swaync` (notifications), `swayidle` (idle), `waybar` (bar), `wlogout` (logout), `fuzzel` (launcher), `cliphist` (clipboard), `wlsunset` (night light)
- Utilities: `fastfetch` (info), `nemo` (file manager), `gdu` (disk), `yazi` (terminal FM), `gnome-calculator`, `firefix` (browser)

### AUR (paru):
- `avizo` (notifications), `xwayland-satellite` (XWayland compat), `tuned` (tuning), `hyprlock` (locker, optional fallback), `hyprpicker` (picker), `wooz` (screenshots)

**Notes**:
- ~30 packages total; AUR builds may take 5-15 minutes (needs RAM/disk space).
- If AUR fails (e.g., dependencies), run `paru -Syu` and retry manually.
- Niri-specific: No additional WM like Hyprland—focus on Niri. Install a display manager if needed: `sudo pacman -S sddm` (then enable: `sudo systemctl enable sddm`).

## Post-Installation

1. **Change Shell**: `chsh -s /usr/bin/fish` (logs you out).
2. **Niri Setup**:
   - Edit `~/.config/niri/config.kdl` for keybinds (e.g., mod=Super, workspaces via numbers).
   - Enable Niri session in your display manager (e.g., SDDM: select "Niri" at login).
3. **Neovim**: `nvim +Lazy sync` (assumes Lazy.nvim; adjust for your plugin manager).
4. **Wayland Tools**:
   - Start Waybar: Add to Niri config or run `waybar &`.
   - Clipboard: Add `cliphist watch` to startup (e.g., via Niri spawn).
   - Notifications: `swaync-client -o` to test.
   - Screenshots: Bind `wooz` in Niri config.
5. **Reboot/Log Out**: Start Niri session. Verify: `ls -la ~/.config | grep -E "(niri|waybar|fish|nvim)"`.
6. **Customization**: Test selectively—unstow with `stow -D <package>` if issues.

## Updates & Maintenance

From `~/dotfiles`:
```bash
git pull
stow -R -v */  # Restow changes
```
- For package updates: `sudo pacman -Syu; paru -Syu`.
- Troubleshooting:
  - Stow conflicts: Use dry-run (`stow -n -v <package>`).
  - Niri Issues: Check `journalctl -b -u sddm` or Niri logs (`niri --log-level debug`).
  - Permissions: `chown -R $USER:$USER ~/dotfiles`.

## Directory Structure

```
dotfiles/
├── README.md                 # This file
├── setup-complete.sh         # Full setup script (curlable)
├── niri/                     # Niri config (config.kdl, themes)
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

Fork and PR modular changes (e.g., new Niri keybinds). Test on Arch with Niri.

## License

MIT License - see [LICENSE](LICENSE) for details.
