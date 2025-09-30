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
  icon="󰖯" # Icon for disconnected (you can change this)
elif [[ "$current_status" == "Disconnected" ]]; then
  warp-cli connect
  new_status="Connected"
  icon="󰖱" # Icon for connected (you can change this)
else
  # Handle error or initial state (Warp not installed/configured properly)
  new_status="Unknown"
  icon="󰟽" # Question mark icon (you can change this)
fi

# Output JSON for Waybar
if [[ "$new_status" == "Connected" ]]; then
  echo "{\"text\": \"<span color='#aaff7f'>Warp: On $icon</span>\", \"tooltip\": \"Cloudflare Warp is Connected\", \"class\": \"warp-connected\"}"
elif [[ "$new_status" == "Disconnected" ]]; then
  echo "{\"text\": \"<span color='#ff5555'>Warp: Off $icon</span>\", \"tooltip\": \"Cloudflare Warp is Disconnected\", \"class\": \"warp-disconnected\"}"
else
  echo "{\"text\": \"Warp: Unknown $icon\", \"tooltip\": \"Cloudflare Warp Status Unknown\", \"class\": \"warp-unknown\"}"
fi
