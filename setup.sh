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
REPO_URL="https://github.com/fyiimysf/Mango-arch-dotfiles.git" 
DOTFILES_DIR="$HOME/Mango-arch-dotfiles"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
░░█▄█░█▀█░█▀█░█▀▀░█▀█░░░█▀▄░█▀█░▀█▀░█▀▀░▀█▀░█░░░█▀▀░█▀▀░░
░░█░█░█▀█░█░█░█░█░█░█░░░█░█░█░█░░█░░█▀▀░░█░░█░░░█▀▀░▀▀█░░
░░▀░▀░▀░▀░▀░▀░▀▀▀░▀▀▀░░░▀▀░░▀▀▀░░▀░░▀░░░▀▀▀░▀▀▀░▀▀▀░▀▀▀░░
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
░░░░░░░░█▀▄░█░█░░░░░█▀▀░█░█░▀█▀░▀█▀░█▄█░█░█░█▀▀░█▀▀░░░░░░
░░░░░░░░█▀▄░░█░░░░░░█▀▀░░█░░░█░░░█░░█░█░░█░░▀▀█░█▀▀░░░░░░
░░░░░░░░▀▀░░░▀░░░░░░▀░░░░▀░░▀▀▀░▀▀▀░▀░▀░░▀░░▀▀▀░▀░░░░░░░░
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
${NC}"
# echo -e "${GREEN}
# ░█▀█░▀█▀░█▀▄░▀█▀░░░█░█░█▄█░░░█▀▄░█▀█░▀█▀░█▀▀░▀█▀░█░░░█▀▀░█▀▀
# ░█░█░░█░░█▀▄░░█░░░░█▄█░█░█░░░█░█░█░█░░█░░█▀▀░░█░░█░░░█▀▀░▀▀█
# ░▀░▀░▀▀▀░▀░▀░▀▀▀░░░▀░▀░▀░▀░░░▀▀░░▀▀▀░░▀░░▀░░░▀▀▀░▀▀▀░▀▀▀░▀▀▀
# ░░░░░░░░░░░█▀▄░█░█░░░█▀▀░█░█░▀█▀░▀█▀░█▄█░█▀▀░█▀▀░░░░░░░░░░░░
# ░░░░░░░░░░░█▀▄░░█░░░░█▀▀░░█░░░█░░░█░░█░█░▀▀█░█▀▀░░░░░░░░░░░░
# ░░░░░░░░░░░▀▀░░░▀░░░░▀░░░░▀░░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀░░░░░░░░░░░░░░
# ${NC}"


echo "Repo URL: $REPO_URL"
echo -e "${RED}This will update system, clone repo, install packages (pacman + AUR via Paru), and stow dotfiles.${NC}"
echo "Backing up your ~/.config."
read -p "Continue? (Y/n): " -n1 bak < /dev/tty
echo < /dev/tty

# Step 1: Backup existing config if present (before any installs)
case "$bak" in
    "N"|"n")
        read -p "Skip Backup? (y/n/Exit): " -n1 cont
        echo
        case "$cont" in
	        "Y"|"y")	    
                echo "Continuing without Backup 🙃."
	        ;;
            "N"|"n")

            	echo "Backing up ~/.config to ~/.config.backup..."
        	    cp -r ~/.config ~/.config.backup
        	    echo -e "${GREEN}Backup complete.${NC}"
            ;;
            *)
                echo -e "${YELLOW}Aborted.${NC}"
                exit 1
            ;;
        esac

    ;;
    *)
        echo "Backing up ~/.config to ~/.config.backup..."
        cp -r ~/.config ~/.config.backup
        echo -e "${GREEN}Backup complete.${NC}"
    ;;
esac

echo "..........................................................................................."
# Step 2: Update system and install prerequisites for AUR and git (base-devel, git)
echo "Updating system and installing prerequisites (base-devel, git, stow)..."
sudo pacman -Syu --noconfirm 
sudo pacman -S --needed --noconfirm base-devel git stow  # Include stow early for later use

# Step 3: Clone the repo if not already present
if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo "Cloning dotfiles repo to $DOTFILES_DIR..."
    git clone --depth=1 "$REPO_URL" "$DOTFILES_DIR"
    echo -e "${GREEN}Repo cloned successfully.${NC}"
else
    echo "Dotfiles repo already exists at $DOTFILES_DIR. Skipping clone."
fi

# Ensure we're in the repo dir for later steps
cd "$DOTFILES_DIR"

paru_install(){
    # Install paru
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
}

yay_install(){
    # Install yay
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
}

read -p "Select AUR Helper to install Yay/Paru/BOTH (y/p/B): " -n 1 aur < /dev/tty
echo < /dev/tty

# # Step 4: Install AUR helper if not present
# if [[ ! $REPLY =~ ^[Bb]$ ]]; then
# echo "Installing Both Yay & Paru..."
# # Install Both
# if ! command -v paru &> /dev/null; then
#     echo "Installing Paru..."
#     cd /tmp
#     rm -rf /tmp/paru
#     git clone https://aur.archlinux.org/paru.git
#     cd paru
#     makepkg -si --noconfirm
#     cd ~
#     rm -rf /tmp/paru
#     echo -e "${GREEN}PARU installed Successfully.${NC}"
# else
#     echo "Paru already installed."
# fi

# if ! command -v yay &> /dev/null; then
    # echo "Installing Yay..."
    # cd /tmp
    # rm -rf /tmp/yay
    # git clone https://aur.archlinux.org/yay.git
    # cd yay
    # makepkg -si --noconfirm
    # cd ~
    # rm -rf /tmp/yay
    # echo -e "${GREEN}YAY installed Successfully.${NC}"
# else
#     echo "Yay already installed."
# fi


# elif [[ ! $REPLY =~ ^[Pp]$ ]]; then
# # Install paru
# if ! command -v paru &> /dev/null; then
#     echo "Installing PARU AUR helper..."
#     cd /tmp
#     rm -rf /tmp/paru
#     git clone https://aur.archlinux.org/paru.git
#     cd paru
#     makepkg -si --noconfirm
#     cd ~
#     rm -rf /tmp/paru
#     echo -e "${GREEN}PARU installed Successfully.${NC}"
# else
#     echo "Paru already installed."
# fi

# elif [[ ! $REPLY =~ ^[Yy]$ ]]; then
# # Install yay
# if ! command -v yay &> /dev/null; then
#     echo "Installing YAY AUR helper..."
#     cd /tmp
#     rm -rf /tmp/yay
#     git clone https://aur.archlinux.org/yay.git
#     cd yay
#     makepkg -si --noconfirm
#     cd ~
#     rm -rf /tmp/yay
#     echo -e "${GREEN}YAY installed Successfully.${NC}"
# else
#     echo "Yay already installed."
# fi


# fi

case "$aur" in
    "Y"|"y")
        yay_install
    ;;
    "P"|"p")
        paru_install
    ;;
    *)
        echo "Installing Both Yay & Paru..."
        yay_install
        paru_install
    ;;
esac

echo "..........................................................................................."


# Step 5: Define package lists
# Official repos (pacman)
OFFICIAL_PACKAGES=(
    "git"           		# Cloning/updating repo
	"xorg"          		# X11
	"wayland"      			# Wayland
	"wlroots"       		# Wayland Root Files
    "stow"          		# Symlink management
    "nvim"          		# Neovim editor
    "curl"          		# Downloads
    "brightnessctl" 		# Brightness control
    "foot"          		# Terminal
    "fish"          		# Shell
	"mangowc-git"   		# Mango Window Manager
    "fastfetch"     		# System info
    "librewolf-bin" 		# Secure Internet Browser
    "swaync"        		# Notifications
    "swayidle"      		# Idle management
    "waybar"        		# Status bar
    "wezterm"       		# Terminal
    "wlogout"       		# Logout menu
    "fuzzel"        		# Launcher
	"rofi"					# Launcher + Clipboard
    "cliphist"      		# Clipboard (community)
    "wlsunset"      		# Night light
    "thunar"          		# File manager
    "gdu"           		# Disk usage
    "yazi"          		# Terminal File Manager
    "alacritty"     		# Terminal
    "gnome-calculator" 		# Calculator
    "kitty"         		# Terminal
    "avizo"                 # OSD Notifications
    "xwayland-satellite"    # XWayland compat
    "tuned"                 # System tuning
    "hyprlock"              # Lock screen
    "hyprpicker"            # Color picker
    "wooz"                  # Screenshot utility (assuming AUR/custom)
	"mesa" 					# General Display drivers
	"waypaper" 				# Wallpaper manager
	"swww"					# Wallpaper package
	"xdg-desktop-portal"	# Desktop Manager
	"xdg-desktop-portal-gtk" # Desktop Manager for Wayland
	"xdg-desktop-portal-wlr" # Desktop Manager for Wayland
    "nwg-look"              # GTK Theme Manager
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

echo -e "Installing All packages: ${GREEN}${OFFICIAL_PACKAGES[*]}${NC}"
# sudo pacman -S --needed --noconfirm "${OFFICIAL_PACKAGES[@]}"

# echo "Installing AUR packages: ${AUR_PACKAGES[*]}"

# if [[ ! $REPLY =~ ^[Yy]$ ]]; then
#   yay -S --needed --noconfirm "${OFFICIAL_PACKAGES[@]}"
# elif [[ ! $REPLY =~ ^[Pp]$ ]]; then
#   paru -S --needed --noconfirm "${OFFICIAL_PACKAGES[@]}"
# else 
#   paru -S --needed --noconfirm "${OFFICIAL_PACKAGES[@]}"
# fi


case "$aur" in
    "Y"|"y")
        echo -e "${YELLOW}Installing Packages using Yay${NC}"
        yay -S --needed --noconfirm "${OFFICIAL_PACKAGES[@]}"
    ;;
    *)
        echo -e "${YELLOW}Installing Packages using Paru${NC}"
        paru -S --needed --noconfirm "${OFFICIAL_PACKAGES[@]}"
    ;;
esac



echo -e "${GREEN}All packages installed successfully!${NC}"

echo "..........................................................................................."

# Step 6: Stow all subdirectories
echo ""
echo "Stowing all dotfiles from $DOTFILES_DIR..."

cd ~/Mango-arch-dotfiles/stow
for dir in */; do
    package="${dir%/}"  # Remove trailing slash
    if [[ -d "$package" ]]; then
        #if [ ! "$package" = "setup.sh" ]&[ ! "$package" = "README.md" ]&[ ! "$package" = ".gitattributes" ]&[ ! "$package" = ".gitignore" ]&[ ! "$package" = "LICENSE" ]&[ ! "$package" = ".git" ]; then
         echo "Stowing $package..."
         stow  -Rv -t '../../' --adopt "$package"
	#fi
    fi
done
cd ..
git restore .

echo -e "${GREEN}Stowing complete!${NC}"

waypaper --wallpaper '~/Pictures/wallpaper/city.gif'
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
echo "3. Reboot or log out/in: Start Mango session from your display manager."
echo "4. Verify: ls -la ~/.config | grep -E '(mango|waybar|nvim|fish)'"
echo "5. For updates later: cd ~/dotfiles; git pull; stow -R -v */"
echo "6. Change Wallpaper: Press Super+Alt+W to open Waypaper."

echo ""
echo -e "${GREEN}Enjoy your new system.${NC}"




# Step 7: Install and setup Ly Display Manager (Optional)
read -p "Do You want to Install Ly Display Manager ? (y/N)" -n1 ly
echo

case "$ly" in
    "Y"|"y")
        echo "Installing Ly Display Manager..."
        sudo pacman -S --noconfirm ly
        sudo systemctl enable --now ly.service
        echo -e "${GREEN}Ly Display Manager installed and enabled successfully.${NC}"
    ;;
    *)
        echo "Skipping Ly Display Manager installation."
    ;;
esac





