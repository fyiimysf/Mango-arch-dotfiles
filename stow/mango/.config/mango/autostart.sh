
#! /bin/bash

set +e

# obs
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots
# The next line of command is not necessary. It is only to avoid some situations where it cannot start automatically
/usr/lib/xdg-desktop-portal-wlr &

# notify
swaync &

# night light
wlsunset -T 5000 &

# wallpaper
#swaybg -i ~/.config/mango/wallpaper/room.png &
waypaper --restore &

# top bar
waybar -c .config/mango/waybar/config.jsonc -s .config/mango/waybar/style.css & # -c ~/.config/mango/waybar/config -s ~/.config/mango/waybar/style.css &

# keep clipboard content
wl-clip-persist --clipboard regular --reconnect-tries 0 &

# clipboard content manager
wl-paste --watch cliphist store &
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &

# xwayland dpi scale
echo "Xft.dpi: 140" | xrdb -merge #dpi缩放
gsettings set org.gnome.desktop.interface text-scaling-factor 1

# Permission authentication
/usr/lib/xfce-polkit/xfce-polkit &


