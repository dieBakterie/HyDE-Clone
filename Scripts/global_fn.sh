#!/usr/bin/env bash
#|---/ /+------------------+---/ /|#
#|--/ /-| Global functions |--/ /-|#
#|-/ /--| derDelphin       |-/ /--|#
#|/ /---+------------------+/ /---|#

set -e

scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/get_distro.sh"
cloneDir="$(dirname "${scrDir}")"
confDir="${XDG_CONFIG_HOME:-$HOME/.config}"
cacheDir="$HOME/.cache/lycr"

#------------------------#
# detect distro and pkgs #
#------------------------#
if [[ $ID_LIKE == "arch" ]]; then
    aurList=(yay paru)
    ntdList=(dunst swaync)
    idlList=(swayidle hypridle hypridle-git)
    lckList=(swaylock-effects-git hyprlock hyprlock-git)
    shlList=(zsh fish bash)
    shdList=(hyprshade hyprshade-git wl-gammarelay-rs)

elif [[ $ID == "nixos" ]]; then
    ntdList=(dunst swaynotificationcenter)
    idlList=(swayidle hypridle)
    lckList=(swaylock-effects hyprlock)
    shlList=(zsh fish bash)
    shdList=(hyprshade wl-gammarelay-rs)

fi

pkg_installed() {
    local PkgIn=$1

    if [[ ${ID} == "nixos" ]]; then
        if nix-store -q --references /var/run/current-system/sw \
            | grep -vE '(-man|-doc|-info)$' \
            | cut -d'-' -f2- \
            | sed -E 's/-[0-9]+(\.[0-9]+)*.*$//' \
            | grep -w "^${PkgIn}$" &> /dev/null; then
            return 0

        else
            return 1
        fi

    elif [[ ${ID_LIKE} == "arch" ]]; then
        if pacman -Qi "${PkgIn}" &> /dev/null; then
            return 0

        else
            return 1
        fi

    fi
}

chk_list() {
    vrType="$1"
    local inList=("${@:2}")
    for pkg in "${inList[@]}"; do
        if pkg_installed "${pkg}"; then
            printf -v "${vrType}" "%s" "${pkg}"
            export "${vrType}"
            return 0
        fi
    done
    return 1
}

pkg_available() {
    local PkgIn=$1

    if [[ ${ID} == "nixos" ]]; then
        if echo -en <(nix-env -f '<nixpkgs>' -qaP -A "${PkgIn}" --no-name &>/dev/null); then
            return 0
        else
            return 1

        fi

    elif [[ ${ID_LIKE} == "arch" ]]; then
        if pacman -Si "${PkgIn}" &> /dev/null; then
            return 0

        else
            return 1
        fi

    fi
}

aur_available() {
    local PkgIn=$1

    if ${aurhlpr} -Si "${PkgIn}" &> /dev/null; then
        return 0

    else
        return 1

    fi
}

nvidia_detect() {
    if [[ $ID == "nixos" ]]; then
        local dGPU=($(nix-shell -p pciutils --run "lspci -k | grep -E '(VGA|3D)' | awk -F ': ' '{print $NF}'"))
        if [ "${1}" == "--verbose" ]; then
            for indx in "${!dGPU[@]}"; do
                echo -e "\033[0;32m[gpu$indx]\033[0m detected // ${dGPU[indx]}"
            done
            return 0
        fi
        if [ "${1}" == "--drivers" ]; then
            while read -r -d ' ' nvcode; do
                nix-shell -p awk --run "awk -F '|' -v nvc=\"${nvcode}\" 'substr(nvc,1,length(\$3)) == \$3 {print \"nvidia-\" \$3 \"-dkms\"}'"
            done <<<"${dGPU[@]}"
            return 0
        fi
        if grep -iq nvidia <<<"${dGPU[@]}"; then
            return 0
        else
            return 1
        fi

    elif [[ $ID_LIKE == "arch" ]]; then
        readarray -t dGPU < <(lspci -k | grep -E "(VGA|3D)" | awk -F ': ' '{print $NF}')
        if [ "${1}" == "--verbose" ]; then
            for indx in "${!dGPU[@]}"; do
                echo -e "\033[0;32m[gpu$indx]\033[0m detected // ${dGPU[indx]}"
            done
            return 0
        fi
        if [ "${1}" == "--drivers" ]; then
            while read -r -d ' ' nvcode; do
                awk -F '|' -v nvc="${nvcode}" 'substr(nvc,1,length($3)) == $3 {split(FILENAME,driver,"/"); print driver[length(driver)],"\nnvidia-utils"}' "${scrDir}"/.nvidia/nvidia*dkms
            done <<<"${dGPU[@]}"
            return 0
        fi
        if grep -iq nvidia <<<"${dGPU[@]}"; then
            return 0
        else
            return 1
        fi
    fi
}

prompt() {
    unset promptIn
    local msg=$1
    echo -ne "\r :: ${msg} : "
    read promptIn
    export promptIn
    echo ""
}
