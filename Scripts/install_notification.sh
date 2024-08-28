#!/usr/bin/env bash
#|---/ /+----------------------------------+---/ /|#
#|--/ /-| Notification installation script |--/ /-|#
#|-/ /--| derDelphin                       |-/ /--|#
#|/ /---+----------------------------------+/ /---|#

scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/global_fn.sh"
if [ $? -ne 0 ]; then
    echo "Error: unable to source global_fn.sh..."
    exit 1
fi

if [[ $ID_LIKE == "arch" ]]; then
    echo -e "Select Notification Daemon or Center:\n[1] dunst\n[2] swaynotificationcenter"
    prompt "Enter option number"

    case "${promptIn}" in
    1) export myNotd="dunst" ;;
    2) export myNotd="dunst-git" ;;
    3) export myNotd="swaync" ;;
    4) export myNotd="swaync-git" ;;
    5) export myNotd="" ;;
    *)
        echo -e "...Invalid option selected..."
        exit 1
        ;;
    esac

elif [[ $ID == "nixos" ]]; then
    echo -e "Select Notification Daemon or Center:\n[1] dunst\n[2] swaynotificationcenter"
    prompt "Enter option number"

    case "${promptIn}" in
    1) export myNotd="dunst" ;;
    2) export myNotd="swaynotificationcenter" ;;
    3) export myNotd="" ;;
    *)
        echo -e "...Invalid option selected..."
        exit 1
        ;;
    esac

fi

if [ "${myNotd}" == "" ]; then
    echo -e "\n\033[0;32m[SKIP]\033[0m Notification Center or daemon: No notification Center or daemon selected, skipping!"
    exit 0
else
    echo -e "\n\033[0;32m[NOTIFICATIONDAEMON/CENTER]\033[0m Notification Center or daemon: ${myNotd}"
    echo "${myNotd}" >>"${scrDir}/install_pkg.lst"

    if [[ $ID_LIKE == "arch" ]]; then
        # remove -git from myNotd for exec-once command
        if [[ "${myNotd}" == *"-git" ]]; then
            myNotd=$(echo "${myNotd}" | sed -E 's/-git$//')
        fi
    fi

    update_exec_once() {
        local file=$1
        local current_notd

        # Searches for the exec-once line that starts the current notification daemon
        current_notd=$(grep -E '^\s*exec-once\s*=\s*[^\s]+ # start notification daemon' "$file" | awk -F '=' '{print $2}' | awk '{print $1}')

        if [[ "${current_notd}" != "${myNotd}" ]]; then
            if grep -q -E '^\s*exec-once\s*=\s*[^\s]+ # start notification daemon' "$file"; then
                # Update existing exec-once line specific to the notification daemon
                sed -i "s|^\(\s*exec-once\s*=\s*\)[^\s]*\(\s*# start notification daemon\)|\1${myNotd}\2|" "$file"
            else
                # Add new exec-once line if no matching line was found
                echo -en "\nexec-once = ${myNotd} # start notification daemon" >>"$file"
            fi
        fi
    }

    # Update or add exec-once line in the configuration file
    update_exec_once "${cloneDir}/Configs/.config/hypr/config/launchs.conf"
fi
