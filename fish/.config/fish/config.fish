if status is-interactive
    # Commands to run in interactive sessions can go here
end

function fish_greeting 
    fastfetch
    echo Salam Yousaf 👋
end

function fish_prompt
      set_color FF0
      echo '['(pwd)']'
      set_color normal 
      echo '--------------➜   '
      
end

function zed
    /home/jfifi/.local/bin/zed
end

function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

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


# Created by `pipx` on 2025-06-28 16:39:14
set PATH $PATH /home/jfifi/.local/bin
