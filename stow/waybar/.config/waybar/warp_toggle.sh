#!/bin/bash

# Function to get Warp status
get_warp_status() {
  warp-cli status | grep "Status update:" | awk '{print $3}'
}

# Get current status
current_status=$(get_warp_status)

# Determine action and new status based on current status
if [[ "$current_status" == "Connected" ]]; then
  warp-cli disconnect
  new_status="Disconnected"
  icon="0" # Icon for disconnected (you can change this)
  notify-send -a warp -i warp "Warp" '1.1.1.1 warp Disconnected ❌'
elif [[ "$current_status" == "Disconnected" ]]; then
  warp-cli connect
  new_status="Connected"
  icon="1" # Icon for connected (you can change this)
  notify-send -a warp -i warp "Warp" '1.1.1.1 warp Connected ✅'
else
  # Handle error or initial state (Warp not installed/configured properly)
  new_status="Unknown"
  icon="?" # Question mark icon (you can change this)
fi

# Output JSON for Waybar
if [[ "$new_status" == "Connected" ]]; then
  echo "{\"text\": \"<span color='#aaff7f'>Warp: On $icon</span>\", \"tooltip\": \"Cloudflare Warp is Connected\", \"class\": \"warp-connected\",  \"icon\": \"<span color='#ffffff'>$icon</span>\"}"
elif [[ "$new_status" == "Disconnected" ]]; then
  echo "{\"text\": \"<span color='#ff5555'>Warp: Off $icon</span>\", \"tooltip\": \"Cloudflare Warp is Disconnected\", \"class\": \"warp-disconnected\",  \"icon\": \"<span color='#ffffff'>$icon</span>\"}"
else
  echo "{\"text\": \"Warp: Unknown $icon\", \"tooltip\": \"Cloudflare Warp Status Unknown\", \"class\": \"warp-unknown\",  \"icon\": \"<span color='#ffffff'>$icon</span>\"}"
fi
