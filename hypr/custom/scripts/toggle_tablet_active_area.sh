#!/bin/bash

# === Configuration ===
TABLET_NAME="sz-ping-it-inc.--t505-graphic-tablet"

# Osu! mode values
OSU_SIZE="39, 61"
OSU_POS="60, 30"

# Standard mode values
STD_SIZE="0, 0"
STD_POS="0, 0"
# =====================

# --- Step 1: Detect current mode ---
if hyprctl getoption input:tablet:active_area_size | grep -q "\[39, 61]"; then
  echo "Osu! mode detected. Switching to Standard mode..."
  hyprctl keyword "input:tablet:active_area_size" "$STD_SIZE"
  hyprctl keyword "input:tablet:active_area_position" "$STD_POS"
  MODE_NAME="Standard"
  FINAL_SIZE=$STD_SIZE
  FINAL_POS=$STD_POS
else
  echo "Standard mode detected. Switching to Osu! mode..."
  hyprctl --batch "keyword input:tablet:active_area_size $OSU_SIZE; keyword input:tablet:active_area_position $OSU_POS"
  MODE_NAME="Osu!"
  FINAL_SIZE=$OSU_SIZE
  FINAL_POS=$OSU_POS
fi

# --- Step 2: Force replug (simulates disconnect/reconnect) ---
echo "Forcing tablet device replug (udev trigger)..."
sudo udevadm trigger --subsystem-match=input --action=remove
sleep 0.3
sudo udevadm trigger --subsystem-match=input --action=add

# --- Step 3: Report final values ---
echo "---------------------------------"
echo "   Switched to $MODE_NAME mode"
echo "   New Size: $FINAL_SIZE"
echo "   New Position: $FINAL_POS"
echo "---------------------------------"

notify-send "Tablet Area Switched" \
  "Mode: <b>$MODE_NAME</b>\nSize: $FINAL_SIZE\nPosition: $FINAL_POS"

