# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"


# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=


alias upD='paru -Syu'
alias pi='paru -S' 
alias pr='paru -R'
alias py='paru --noconfirm -S'
# alias pry='paru -Ry'
alias ps='paru'
alias ff='fastfetch'
alias nf='neofetch'
alias unlock='sudo rm /var/lib/pacman/db.lck'
alias mpvid=' mpv --really-quiet --vo=tct --vo-tct-buffering=frame'


# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc


# Load Angular CLI autocompletion.
source <(ng completion script)
