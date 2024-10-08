#!/usr/bin/env sh

# set variables
scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/globalcontrol.sh"

# hyprland gamemode
HYPRGAMEMODE=$(hyprctl getoption animations:enabled | sed -n '1p' | awk '{print $2}')

# waybar performance
FILE="${confDir}/waybar/style.css"

sed -i 's/\/\* \(.*animation:.*\) \*\//\1/g' "$FILE"
sed -i 's/\/\* \(.*transition:.*\) \*\//\1/g' "$FILE"
if [ "$HYPRGAMEMODE" = 1 ]; then
	sed -i 's/^\(.*animation:.*\)$/\/\* \1 \*\//g' "$FILE"
	sed -i 's/^\(.*transition:.*\)$/\/\* \1 \*\//g' "$FILE"
fi
killall waybar
waybar >/dev/null 2>&1 &

# hyprland performance
if [ "$HYPRGAMEMODE" = 1 ]; then
	hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:drop_shadow 0;\
        keyword decoration:blur:enabled 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword decoration:rounding 0"
	exit
else
	hyprctl reload
fi