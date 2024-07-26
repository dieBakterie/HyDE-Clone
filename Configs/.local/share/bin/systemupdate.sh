#!/usr/bin/env bash
# shellcheck disable=SC2154
# shellcheck disable=SC1091

# check release
if [ ! -f /etc/arch-release ]; then
    exit 0
fi

# set variables
scrDir="$(dirname "$(realpath "$0")")"
source "$scrDir/globalcontrol.sh"
get_aurhlpr
export -f pkg_installed
fpk_exup="pkg_installed flatpak && flatpak update"

# trigger upgrade
if [ "$1" == "up" ]; then
    trap 'pkill -RTMIN+20 waybar' EXIT
    command="
    fastfetch
    $0 upgrade
    ${aurhlpr} -Syu
    $fpk_exup
    read -n 1 -p 'Press any key to continue...'
    "
    kitty --title systemupdate sh -c "${command}"
fi

# check for AUR updates
aur=$(${aurhlpr} -Qua | wc -l)
ofc=$(
    (while pgrep -x checkupdates >/dev/null; do sleep 1; done)
    checkupdates | wc -l
)

# check for flatpak updates
if pkg_installed flatpak; then
    fpk=$(flatpak remote-ls --updates | wc -l)
    fpk_disp="\n󰏓 Flatpak $fpk"
else
    fpk=0
    fpk_disp=""
fi

# calculate total available updates
upd=$((ofc + aur + fpk))

[ "${1}" == upgrade ] && printf "[Official] %-10s\n[AUR]      %-10s\n[Flatpak]  %-10s\n" "$ofc" "$aur" "$fpk" && exit

# show tooltip
if [ $upd -eq 0 ]; then
    upd="" # remove Icon completely
    # upd="󰮯" # if zero Display Icon only
    echo "{\"text\":\"$upd\", \"tooltip\":\" Packages are up to date\"}"
else
    # shellcheck disable=SC2028
    echo "{\"text\":\"󰮯 $upd\", \"tooltip\":\"󱓽 Official $ofc\n󱓾 AUR $aur$fpk_disp\"}"
fi