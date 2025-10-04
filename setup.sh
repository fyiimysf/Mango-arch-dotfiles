 #!/bin/bash

# setup.sh
# Comprehensive setup script for Arch Linux dotfiles, runnable via curl on a fresh system.
# 1. Updates system and installs prerequisites (including git).
# 2. Clones the dotfiles repo to ~/dotfiles if not already present.
# 3. Installs AUR helper if not present.
# 4. Installs official pacman packages.
# 5. Installs AUR packages via Paru.
# 6. Stows all subdirectories using GNU Stow.
#
# Assumes: Fresh Arch Linux or derivative (e.g., after archinstall). Internet and sudo access required.
# WARNINGS:
# - This is a destructive setup: Backs up ~/.config but overwrites with symlinks.
# - AUR installs can take time; review source before running.
# - Customize PACKAGE lists and REPO_URL below if needed.
# - After run: chsh -s /usr/bin/fish; reboot for Wayland/Hyprland.
# - Security: Only run trusted scripts via curl|bash. Review code first!

set -e  # Exit on error

# Configuration
REPO_URL="https://github.com/fyiimysf/Niri-arch-dotfiles.git" 
DOTFILES_DIR="$HOME/dotfiles"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}
░█▀█░▀█▀░█▀▄░▀█▀░░░█░█░█▄█░░░█▀▄░█▀█░▀█▀░█▀▀░▀█▀░█░░░█▀▀░█▀▀
░█░█░░█░░█▀▄░░█░░░░█▄█░█░█░░░█░█░█░█░░█░░█▀▀░░█░░█░░░█▀▀░▀▀█
░▀░▀░▀▀▀░▀░▀░▀▀▀░░░▀░▀░▀░▀░░░▀▀░░▀▀▀░░▀░░▀░░░▀▀▀░▀▀▀░▀▀▀░▀▀▀
░░░░░░░░░░░█▀▄░█░█░░░█▀▀░█░█░▀█▀░▀█▀░█▄█░█▀▀░█▀▀░░░░░░░░░░░░
░░░░░░░░░░░█▀▄░░█░░░░█▀▀░░█░░░█░░░█░░█░█░▀▀█░█▀▀░░░░░░░░░░░░
░░░░░░░░░░░▀▀░░░▀░░░░▀░░░░▀░░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀░░░░░░░░░░░░░░
${NC}"
echo "Repo URL: $REPO_URL"
echo -e "${RED}This will update system, clone repo, install packages (pacman + AUR via Paru), and stow dotfiles.${NC}"
echo "Backup your ~/.config first if needed (script will auto-backup)."
read -p "Continue? (y/N): " -n 1 < /dev/tty
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Aborted.${NC}"
    exit 1
fi

# Step 1: Backup existing config if present (before any installs)
if [[ -d ~/.config ]]; then
    echo "Backing up ~/.config to ~/.config.backup..."
    cp -r ~/.config ~/.config.backup
    echo -e "${GREEN}Backup complete.${NC}"
fi

# Step 2: Update system and install prerequisites for AUR and git (base-devel, git)
echo "Updating system and installing prerequisites (base-devel, git, stow)..."
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm base-devel git stow  # Include stow early for later use

# Step 3: Clone the repo if not already present
if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo "Cloning dotfiles repo to $DOTFILES_DIR..."
    git clone "$REPO_URL" "$DOTFILES_DIR"
    echo -e "${GREEN}Repo cloned successfully.${NC}"
else
    echo "Dotfiles repo already exists at $DOTFILES_DIR. Skipping clone."
fi

# Ensure we're in the repo dir for later steps
cd "$DOTFILES_DIR"

read -p "Select AUR Helper to install (Yay/Paru/both)? (y/p/B): " -n 1 < /dev/tty
echo

# Step 4: Install AUR helper if not present
if [[ ! $REPLY =~ ^[Pp]$ ]]; then
# Install paru
if ! command -v paru &> /dev/null; then
    echo "Installing PARU AUR helper..."
    cd /tmp
    rm -rf /tmp/paru
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si --noconfirm
    cd ~
    rm -rf /tmp/paru
    echo -e "${GREEN}PARU installed Successfully.${NC}"
else
    echo "Paru already installed."
fi

elif [[ ! $REPLY =~ ^[Yy]$ ]]; then
# Install yay
if ! command -v yay &> /dev/null; then
    echo "Installing YAY AUR helper..."
    cd /tmp
    rm -rf /tmp/yay
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
    rm -rf /tmp/yay
    echo -e "${GREEN}YAY installed Successfully.${NC}"
else
    echo "Yay already installed."
fi

elif [[ ! $REPLY =~ ^[Bb]$ ]]; then
echo "Installing Both Yay & Paru..."
# Install Both
if ! command -v paru &> /dev/null; then
    echo "Installing Paru..."
    cd /tmp
    rm -rf /tmp/paru
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si --noconfirm
    cd ~
    rm -rf /tmp/paru
    echo -e "${GREEN}PARU installed Successfully.${NC}"
else
    echo "Paru already installed."
fi

if ! command -v yay &> /dev/null; then
    echo "Installing Yay..."
    cd /tmp
    rm -rf /tmp/yay
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
    rm -rf /tmp/yay
    echo -e "${GREEN}YAY installed Successfully.${NC}"
else
    echo "Yay already installed."
fi

else
echo "Installing Both Yay & Paru..."

if ! command -v paru &> /dev/null; then
    echo "Installing Paru..."
    cd /tmp
    rm -rf /tmp/paru
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si --noconfirm
    cd ~
    rm -rf /tmp/paru
    echo -e "${GREEN}PARU installed Successfully.${NC}"
else
    echo "Paru already installed."
fi

if ! command -v yay &> /dev/null; then
    echo "Installing Yay..."
    cd /tmp
    rm -rf /tmp/yay
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
    rm -rf /tmp/yay
    echo -e "${GREEN}YAY installed Successfully.${NC}"
else
    echo "Yay already installed."
fi

fi

# Step 7: Install and setup Ly Display Manager (Optional)

read -p "Do You want to Install Ly Display Manager ? (y/N)" -n 1 ly
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Installing Ly..."
    sudo pacman -S ly
    systemctl enable --now ly
    echo -e "${GREEN}Ly DM Installed.${NC}"
else
    echo "Skipping Ly Install..."
fi

# Step 5: Define package lists
# Official repos (pacman)
OFFICIAL_PACKAGES=(
    "git"           # Cloning/updating repo
    "stow"          # Symlink management
    "nvim"          # Neovim editor
    "curl"          # Downloads
    "brightnessctl" # Brightness control
    "foot"          # Terminal
    "fish"          # Shell
    "niri"          # Wayland compositor
    "fastfetch"     # System info
    "firefox"       # Secure Internet Browser
    "swaync"        # Notifications
    "swayidle"      # Idle management
    "waybar"        # Status bar
    "wezterm"       # Terminal
    "wlogout"       # Logout menu
    "fuzzel"        # Launcher
    "cliphist"      # Clipboard (community)
    "wlsunset"      # Night light
    "nemo"          # File manager
    "gdu"           # Disk usage
    "yazi"          # Terminal FM
    "alacritty"     # Terminal
    "gnome-calculator" # Calculator
    "kitty"         # Terminal
    "avizo"                 # Notifications (AUR)
    "xwayland-satellite"    # XWayland compat
    "tuned"                 # System tuning
    "hyprlock"              # Lock screen
    "hyprpicker"            # Color picker
    "wooz"                  # Screenshot utility (assuming AUR/custom)

)

# # AUR packages
# AUR_PACKAGES=(
#     "avizo"                 # Notifications (AUR)
#     "xwayland-satellite"    # XWayland compat
#     "tuned"                 # System tuning
#     "hyprlock"              # Lock screen
#     "hyprpicker"            # Color picker
#     "wooz"                  # Screenshot utility (assuming AUR/custom)
# )

echo "Installing All packages: ${OFFICIAL_PACKAGES[*]}"
# sudo pacman -S --needed --noconfirm "${OFFICIAL_PACKAGES[@]}"

# echo "Installing AUR packages: ${AUR_PACKAGES[*]}"

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  yay -S --needed --noconfirm "${OFFICIAL_PACKAGES[@]}"
elif [[ ! $REPLY =~ ^[Pp]$ ]]; then
  paru -S --needed --noconfirm "${OFFICIAL_PACKAGES[@]}"
else 
  yay -S --needed --noconfirm "${OFFICIAL_PACKAGES[@]}"
fi

echo -e "${GREEN}All packages installed successfully!${NC}"

# Step 6: Stow all subdirectories
echo ""
echo "Stowing all dotfiles from $DOTFILES_DIR..."
for dir in */; do
    package="${dir%/}"  # Remove trailing slash
    if [[ -d "$package" ]]; then
        echo "Stowing $package..."
        stow -v "$package"
    fi
done

echo -e "${GREEN}Stowing complete!${NC}"


# Step 7: Install and setup Ly Display Manager (Optional)
read -p "Do You want to Install Ly Display Manager ? (y/N)" -n 1 < /dev/tty
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Installing Ly..."
    sudo pacman -S ly
    echo "Enabling Ly"
    systemctl enable --now ly
    echo -e "${GREEN}Ly DM Installed.${NC}"
else
    echo "Skipping Ly Install..."
fi


echo ""
echo -e "${GREEN}
               ▄▖  ▗       ▄▖       ▜   ▗   
               ▚ █▌▜▘▌▌▛▌  ▌ ▛▌▛▛▌▛▌▐ █▌▜▘█▌
               ▄▌▙▖▐▖▙▌▙▌  ▙▖▙▌▌▌▌▙▌▐▖▙▖▐▖▙▖
                       ▌          ▌         
${NC}"
echo "=== Post-Setup Instructions ==="
echo "1. Change to Fish shell: chsh -s /usr/bin/fish (if needed)"
echo "2. Neovim plugins: nvim +Lazy sync (or your plugin manager)."
echo "3. Reboot or log out/in: Start Hyprland session from your display manager."
echo "4. Verify: ls -la ~/.config | grep -E '(hypr|waybar|nvim|fish)'"
echo "5. For updates later: cd ~/dotfiles; git pull; stow -R -v */"
echo ""
echo -e "${GREEN}Enjoy your new system.${NC}"


