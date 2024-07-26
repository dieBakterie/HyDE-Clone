#!/bin/env bash

# check if the battery directory exists
if [ -d "/sys/class/power_supply/BAT0" ]; then
#if [ -d "/sys/class/power_supply/BAT0" ] || [ -d "/sys/class/power_supply/BAT1" ] || [ -d "/sys/class/power_supply/BAT2" ]; then
  # get the current battery percentage
  battery_percentage=$(cat /sys/class/power_supply/BAT0/capacity)

  # get the battery status (Charging or Discharging)
  battery_status=$(cat /sys/class/power_supply/BAT0/status)

  # define the battery icons for each 10% segment
  battery_icons=("󰂃" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰁹")

  # define the charging icon
  charging_icon="󰂄"

  # calculate the index for the icon array
  icon_index=$((battery_percentage / 10))

  # get the corresponding icon
  battery_icon=${battery_icons[icon_index]}

  # check if the battery is charging
  if [ "$battery_status" = "Charging" ]; then
    battery_icon="$charging_icon"
  fi

  # output the battery percentage and icon
  echo "$battery_percentage% $battery_icon"
fi