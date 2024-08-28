#!/usr/bin/env bash
#|---/ /+--------------------------------+---/ /|#
#|--/ /-| Screenlock installation script |--/ /-|#
#|-/ /--| derDelphin                     |-/ /--|#
#|/ /---+--------------------------------+/ /---|#

scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/global_fn.sh"
if [ $? -ne 0 ]; then
    echo "Error: unable to source global_fn.sh..."
    exit 1
fi

if [[ $ID_LIKE == "arch" ]]; then
    echo -e "Select lock screen:\n[1] swaylock-effects\n[2] swaylock-effects-git\n[3] hyprlock\n [4] hyprlock-git\n[5] No lockscreen"
    prompt "Enter option number"

    case "${promptIn}" in
    1) export myLock="swaylock-effects" ;;
    2) export myLock="swaylock-effects-git" ;;
    3) export myLock="hyprlock" ;;
    4) export myLock="hyprlock-git" ;;
    5) export myLock="" ;;
    *)
        echo -e "...Invalid option selected..."
        exit 1
        ;;
    esac

elif [[ $ID == "nixos" ]]; then
    echo -e "Select lock screen:\n[1] swaylock-effects\n[2] hyprlock\n[3] No lockscreen"
    prompt "Enter option number"

    case "${promptIn}" in
    1) export myLock="swaylock-effects"
       export myLock2="swaylock-fancy"
       ;;
    2) export myLock="hyprlock" ;;
    3) export myLock="" ;;
    *)
        echo -e "...Invalid option selected..."
        exit 1
        ;;
    esac

fi

# skip if user selects "" as lockscreen
if [ "${myLock}" == "" ]; then
    echo -e "\n\033[0;32m[SKIP]\033[0m Lockscreen: No Lock Screen selected, skipping!"
    exit 0
else
    echo -e "\n\033[0;32m[LOCKSCREEN]\033[0m Lockscreen: ${myLock}"
    echo "${myLock} ${myLock2}" >>"${scrDir}/install_pkg.lst"

    if [[ $ID_LIKE == "arch" ]]; then
        # remove -git or -effects-git from myLock
        if [[ "${myLock}" == *"-git" || "${myLock}" == *"-effects-git" ]]; then
            myLock=$(echo "${myLock}" | sed -E 's/-.*$//')
        fi
    fi

    # Function to update the lock screen in a file if they do not match
    update_lock_screen() {
        local file=$1
        local current_lock

        # Searches for the lockScreen variable in the file
        current_lock=$(grep -E '^\s*\$lockScreen\s*=\s*[^\s]+ # set lock screen' "$file" | awk -F '=' '{print $2}' | awk '{print $1}')
        if [[ "${current_lock}" != "${myLock}" ]]; then
            sed -i "s|^\(\s*\$lockScreen\s*=\s*\)[^\s]*\(\s*# set lock screen\)|\1${myLock}\2|" "$file"
        fi
    }

    # Always update the lockscreen in hyprland.conf
    current_lock_hyprland=$(grep -E '^\s*\$lockScreen\s*=\s*[^\s]+ # set lock screen' "${cloneDir}/Configs/.config/hypr/hyprland.conf" | awk -F '=' '{print $2}' | awk '{print $1}')
    if [[ "${current_lock_hyprland}" != "${myLock}" ]]; then
        update_lock_screen "${cloneDir}/Configs/.config/hypr/hyprland.conf"
    fi

    # Update the lockscreen in hypridle.conf only if myIdle is set to hypridle
    if [[ "${myIdle}" == "hypridle" ]]; then
        current_lock_hypridle=$(grep -E '^\s*\$lockScreen\s*=\s*[^\s]+ # set lock screen' "${cloneDir}/Configs/.config/hypr/hypridle.conf" | awk -F '=' '{print $2}' | awk '{print $1}')
        if [[ "${current_lock_hypridle}" != "${myLock}" ]]; then
            update_lock_screen "${cloneDir}/Configs/.config/hypr/hypridle.conf"
        fi
    fi
fi
