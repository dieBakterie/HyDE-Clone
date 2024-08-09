#!/usr/bin/env bash
#|---/ /+--------------------------+---/ /|#
#|--/ /-| Idle installation script |--/ /-|#
#|-/ /--| Prasanth Rangan          |-/ /--|#
#|/ /---+--------------------------+/ /---|#

scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/global_fn.sh"
if [ $? -ne 0 ]; then
    echo "Error: unable to source global_fn.sh..."
    exit 1
fi

echo -e "Select idle manager:\n[1] swayidle\n[2] swayidle-git\n[3] hypridle\n[4] hypridle-git\n[5] No Idle Manager"
prompt_timer 120 "Enter option number"

case "${promptIn}" in
1) export myIdle="swayidle" ;;
2) export myIdle="swayidle-git" ;;
3) export myIdle="hypridle" ;;
4) export myIdle="hypridle-git" ;;
5) export myIdle="" ;;
*)
    echo -e "...Invalid option selected..."
    exit 1
    ;;
esac

# skip if user selects "" as idle manager
if [ "${myIdle}" == "" ]; then
    echo -e "\n\033[0;32m[SKIP]\033[0m Idle Manager: No Idle Manager selected, skipping!"
    exit 0
else
    echo -e "\n\033[0;32m[IDLEMANAGER]\033[0m Idle Manager: ${myIdle}"
    echo "${myIdle}" >>"${scrDir}/install_pkg.lst"

    # remove -git from myIdle for exec-once command
    if [[ "${myIdle}" == *"-git" ]]; then
        myIdle=$(echo "${myIdle}" | sed -E 's/-git$//')
    fi

    update_exec_once() {
        local file=$1
        local current_idle
        current_idle=$(grep -E '^exec-once = [^ ]+ # start idle manager' "$file" | awk -F ' = ' '{print $2}' | awk '{print $1}')

        if [ "${current_idle}" != "${myIdle}" ]; then
            if grep -q -E "^exec-once = [^ ]+ #" "$file"; then
                # Update existing exec-once line
                sed -i "s|^\(exec-once = \)[^ ]*\( #.*\)|\1${myIdle} # start idle manager|" "$file"
            else
                # Add new exec-once line
                echo -en "\nexec-once = ${myIdle} # start idle manager" >>"$file"
            fi
        fi
    }

    # Update or add exec-once line in the configuration file
    update_exec_once "${cloneDir}/Configs/.config/hypr/config/launchs.conf"
fi
