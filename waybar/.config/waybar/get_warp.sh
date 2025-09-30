#!/bin/bash

# Function to get Warp status
get_warp_status() {
  warp-cli status | grep "Status update:" | awk '{print $3}'
}

# Get current status
current_status=$(get_warp_status)

# Determine status text, icon, and class based on current status
if [[ "$current_status" == "Connected" ]]; then
  status_text="1.1.1.1"
#   icon="🌝" # Icon for connected
  class="warp-connected"
  tooltip="Cloudflare Warp is Connected"
elif [[ "$current_status" == "Disconnected" ]]; then
  status_text="0.0.0.0"
#   icon="🌚" # Icon for disconnected
  class="warp-disconnected"
  tooltip="Cloudflare Warp is Disconnected"
else
  status_text="?.?.?.?"
#   icon="?" # Question mark icon
  class="warp-unknown"
  tooltip="Cloudflare Warp Status Unknown"
fi

# Output JSON for Waybar
echo "{\"text\": \"<span color='#ffffff'>$status_text $icon</span>\", \"tooltip\": \"$tooltip\", \"class\": \"$class\", \"icons\": \"<span color='#ffffff'>$icon</span>\"}"
