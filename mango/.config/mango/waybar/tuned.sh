#!/usr/bin/env bash
#
# # Define icons for each profile (using Font Awesome icons as example)
# declare -A icons=(
#     ["accelerator-performance"]=""
#     ["balanced"]=""
#     ["powersave"]=""
# )
#
# # Define the order of profiles to cycle through
# profiles=("accelerator-performance" "balanced" "powersave")
#
# # Get current profile
# current_profile=$(tuned-adm active | awk '{print $4}' | sed 's/"//g')
#
# # Determine icon based on current profile
# if [[ -v icons[$current_profile] ]]; then
#     icon=${icons[$current_profile]}
# else
#     icon="" # Question mark icon for unknown profile
# fi
#
# # Output for Waybar
# if [[ "$1" == "--click" ]]; then
#     # Find current profile index
#     current_index=0
#     for i in "${!profiles[@]}"; do
#         if [[ "${profiles[$i]}" == "$current_profile" ]]; then
#             current_index=$i
#             break
#         fi
#     done
#
#     # Calculate next profile index
#     next_index=$(( (current_index + 1) % ${#profiles[@]} ))
#     next_profile=${profiles[$next_index]}
#
#     # Apply new profile (requires sudo, so you'll need passwordless sudo for tuned-adm)
#     tuned-adm profile "$next_profile"
#
#     # Update current profile and icon
#     current_profile=$next_profile
#     icon=${icons[$current_profile]}
# fi
#
# # Output JSON for Waybar
# echo "{\"text\":\"$icon $current_profile\", \"tooltip\":\"Power Profile: $current_profile\"}"


#!/usr/bin/env bash

# Define icons and colors for each profile
declare -A icons=(
    ["accelerator-performance"]=""
    ["balanced"]=""
    ["powersave"]=""
)

declare -A colors=(
    ["accelerator-performance"]="#ff5555"  # Red
    ["balanced"]="#50fa7b"                # Green
    ["powersave"]="#bd93f9"               # Purple
)

profiles=("accelerator-performance" "balanced" "powersave")

current_profile=$(tuned-adm active | awk '{print $4}' | sed 's/"//g' 2>/dev/null)

# Default values for unknown profiles
icon=""
color="#ffb86c"  # Orange for unknown
class="unknown"

if [[ -v icons[$current_profile] ]]; then
    icon=${icons[$current_profile]}
    color=${colors[$current_profile]}
    class="$current_profile"
fi

if [[ "$1" == "--click" ]]; then
    current_index=0
    for i in "${!profiles[@]}"; do
        if [[ "${profiles[$i]}" == "$current_profile" ]]; then
            current_index=$i
            break
        fi
    done

    next_index=$(( (current_index + 1) % ${#profiles[@]} ))
    next_profile=${profiles[$next_index]}

    tuned-adm profile "$next_profile"
#     2>/dev/null

    current_profile=$next_profile
    icon=${icons[$current_profile]}
    color=${colors[$current_profile]}
    class="$current_profile"
fi

# Proper JSON output with printf to avoid newline issues
printf '{"text":"%s","tooltip":"Current tuned profile: %s\\nClick to cycle profile","class":"%s","style":"color: %s"}' \
       "$icon" "$current_profile" "$current_profile" "$class" "$color"
