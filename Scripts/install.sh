#!/usr/bin/env bash
#|---/ /+--------------------------+---/ /|#
#|--/ /-| Main installation script |--/ /-|#
#|-/ /--| Prasanth Rangan          |-/ /--|#
#|/ /---+--------------------------+/ /---|#

cat << EOF

-------------------------------------------------
        .
       / \         _       _  _      ___  ___
      /^  \      _| |_    | || |_  _|   \| __|
     /  _  \    |_   _|   | __ | || | |) | _|
    /  | | ~\     |_|     |_||_|\_, |___/|___|
   /.-'   '-.\                  |__/

-------------------------------------------------

EOF

#--------------------------------#
# import variables and functions #
#--------------------------------#
scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/global_fn.sh"
if [ $? -ne 0 ]; then
    echo "Error: unable to source global_fn.sh..."
    exit 1
fi

#------------------#
# evaluate options #
#------------------#
flg_Install=0
flg_Restore=0
flg_Service=0

while getopts idrs RunStep; do
    case $RunStep in
        i)  flg_Install=1 ;;
        d)  flg_Install=1 ; export use_default="--noconfirm" ;;
        r)  flg_Restore=1 ;;
        s)  flg_Service=1 ;;
        *)  echo "...valid options are..."
            echo "i : [i]nstall hyprland without configs"
            echo "d : install hyprland [d]efaults without configs --noconfirm"
            echo "r : [r]estore config files"
            echo "s : enable system [s]ervices"
            exit 1 ;;
    esac
done

if [ $OPTIND -eq 1 ]; then
    flg_Install=1
    flg_Restore=1
    flg_Service=1
fi

#--------------------#
# pre-install script #
#--------------------#
if [ ${flg_Install} -eq 1 ] && [ ${flg_Restore} -eq 1 ]; then
    cat << "EOF"
                _         _       _ _
 ___ ___ ___   |_|___ ___| |_ ___| | |
| . |  _| -_|  | |   |_ -|  _| .'| | |
|  _|_| |___|  |_|_|_|___|_| |__,|_|_|
|_|

EOF

    "${scrDir}/install_pre.sh"
fi

#------------#
# installing #
#------------#
if [ ${flg_Install} -eq 1 ]; then
    cat << "EOF"

 _         _       _ _ _
|_|___ ___| |_ ___| | |_|___ ___
| |   |_ -|  _| .'| | | |   | . |
|_|_|_|___|_| |__,|_|_|_|_|_|_  |
                            |___|

EOF

    #----------------------#
    # prepare package list #
    #----------------------#
    shift $((OPTIND - 1))
    cust_pkg=$1
    cp "${scrDir}/custom_hypr.lst" "${scrDir}/install_pkg.lst"

    if [ -f "${cust_pkg}" ] && [ -n "${cust_pkg}" ]; then
        cat "${cust_pkg}" >> "${scrDir}/install_pkg.lst"
    fi

    #--------------------------------#
    # add nvidia drivers to the list #
    #--------------------------------#
    if nvidia_detect; then
        cat /usr/lib/modules/*/pkgbase | while read krnl; do
            echo "${krnl}-headers" >> "${scrDir}/install_pkg.lst"
        done
        nvidia_detect --drivers >> "${scrDir}/install_pkg.lst"
    fi

    nvidia_detect --verbose

    #----------------#
    # get user prefs #
    #----------------#
    if ! chk_list "aurhlpr" "${aurList[@]}"; then
        echo -e "Available aur helpers:\n[1] yay\n[2] paru"
        prompt_timer 120 "Enter option number"

        case "${promptIn}" in
            1) export getAur="yay" ;;
            2) export getAur="paru" ;;
            *) echo -e "...Invalid option selected..." ; exit 1 ;;
        esac
    fi

    if ! chk_list "myLock" "${lckList[@]}"; then
        echo -e "Select lock screen:\n[1] swaylock-effects-git\n[2] hyprlock\n[3] hyprlock-git"
        prompt_timer 120 "Enter option number"

        case "${promptIn}" in
            1) export myLock="swaylock-effects-git" ;;
            2) export myLock="hyprlock" ;;
            3) export myLock="hyprlock-git" ;;
            *) echo -e "...Invalid option selected..." ; exit 1 ;;
        esac
        echo -e "\n\033[0;32m[userprefs]\033[0m Lockscreen: ${myLock}"
        echo "${myLock}" >> "${scrDir}/install_pkg.lst"
        myLock=$(echo "${myLock}" | sed -E 's/-.*$//')
        sed -i "s/^\(\$lockScreen = \).*/\1$myLock/" "${cloneDir}/Configs/.config/hypr/hyprland.conf"
        sed -i "s/^\(\$lockScreen = \).*/\1$myLock/" "${cloneDir}/Configs/.config/hypr/hypridle.conf"
    fi

    if ! chk_list "myIdle" "${idlList[@]}"; then
        echo -e "Select idle manager:\n[1] swayidle\n[2] hypridle\n[3] hypridle-git\n[4] none"
        prompt_timer 120 "Enter option number"

        case "${promptIn}" in
            1) export myIdle="swayidle" ;;
            2) export myIdle="hypridle" ;;
            3) export myIdle="hypridle-git" ;;
            4) export myIdle="" ;;
            *) echo -e "...Invalid option selected..." ; exit 1 ;;
        esac
        echo -e "\n\033[0;32m[userprefs]\033[0m Idle manager: ${myIdle}"
        echo "${myIdle}" >> "${scrDir}/install_pkg.lst"
        myIdle=$(echo "${myIdle}" | sed -E 's/-.*$//')
        sed -i "s/^\(\$idleManager = \).*/\1$myIdle/" "${cloneDir}/Configs/.config/hypr/configs/launchs.conf"
    fi

    if ! chk_list "myNotd" "${ntdList[@]}"; then
        echo -e "Select Notification Daemon or Center:\n[1] dunst\n[2] dunst-git\n[3] swaync\n[4] swaync-git"
        prompt_timer 120 "Enter option number"

        case "${promptIn}" in
            1) export myNotd="dunst" ;;
            2) export myNotd="dunst-git" ;;
            3) export myNotd="swaync" ;;
            4) export myNotd="swaync-git" ;;
            *) echo -e "...Invalid option selected..." ; exit 1 ;;
        esac
        echo -e "\n\033[0;32m[userfprefs]\033[0m Notification Daemon or Center: ${myNotd}"
        echo "${myNotd}" >> "${scrDir}/install_pkg.lst"
        myNotd=$(echo "${myNotd}" | sed -E 's/-.*$//')
        sed -i "s/^\(\$notificationDaemon = \).*/\1$myNotd/" "${cloneDir}/Configs/.config/hypr/configs/launchs.conf"
    fi

    if ! chk_list "myShell" "${shlList[@]}"; then
        echo -e "Select shell:\n[1] zsh\n[2] fish"
        prompt_timer 120 "Enter option number"

        case "${promptIn}" in
            1) export myShell="zsh" ;;
            2) export myShell="fish" ;;
            *) echo -e "...Invalid option selected..." ; exit 1 ;;
        esac
        echo -e "\n\033[0;32m[userprefs]\033[0m Shell: ${myShell}"
        echo "${myShell}" >> "${scrDir}/install_pkg.lst"
    fi

    #--------------------------------#
    # install packages from the list #
    #--------------------------------#
    "${scrDir}/install_pkg.sh" "${scrDir}/install_pkg.lst"
    rm "${scrDir}/install_pkg.lst"
fi

#---------------------------#
# restore my custom configs #
#---------------------------#
if [ ${flg_Restore} -eq 1 ]; then
    cat << "EOF"

             _           _
 ___ ___ ___| |_ ___ ___|_|___ ___
|  _| -_|_ -|  _| . |  _| |   | . |
|_| |___|___|_| |___|_| |_|_|_|_  |
                              |___|

EOF

    "${scrDir}/restore_fnt.sh"
    "${scrDir}/restore_cfg.sh"
    echo -e "\n\033[0;32m[themepatcher]\033[0m Patching themes..."
    while IFS='"' read -r null1 themeName null2 themeRepo
    do
        themeNameQ+=("${themeName//\"/}")
        themeRepoQ+=("${themeRepo//\"/}")
        themePath="${confDir}/hyde/themes/${themeName}"
        [ -d "${themePath}" ] || mkdir -p "${themePath}"
        [ -f "${themePath}/.sort" ] || echo "${#themeNameQ[@]}" > "${themePath}/.sort"
    done < "${scrDir}/themepatcher.lst"
    parallel --bar --link "${scrDir}/themepatcher.sh" "{1}" "{2}" "{3}" "{4}" ::: "${themeNameQ[@]}" ::: "${themeRepoQ[@]}" ::: "--skipcaching" ::: "false"
    echo -e "\n\033[0;32m[cache]\033[0m generating cache files..."
    "$HOME/.local/share/bin/swwwallcache.sh" -t ""
    if printenv HYPRLAND_INSTANCE_SIGNATURE &> /dev/null; then
        "$HOME/.local/share/bin/themeswitch.sh" &> /dev/null
    fi
fi

#---------------------#
# post-install script #
#---------------------#
if [ ${flg_Install} -eq 1 ] && [ ${flg_Restore} -eq 1 ]; then
    cat << "EOF"

             _      _         _       _ _
 ___ ___ ___| |_   |_|___ ___| |_ ___| | |
| . | . |_ -|  _|  | |   |_ -|  _| .'| | |
|  _|___|___|_|    |_|_|_|___|_| |__,|_|_|
|_|

EOF

    "${scrDir}/install_pst.sh"
fi

#------------------------#
# enable system services #
#------------------------#
if [ ${flg_Service} -eq 1 ]; then
    cat << "EOF"

                 _
 ___ ___ ___ _ _|_|___ ___ ___
|_ -| -_|  _| | | |  _| -_|_ -|
|___|___|_|  \_/|_|___|___|___|

EOF

    while read servChk; do

        if [[ $(systemctl list-units --all -t service --full --no-legend "${servChk}.service" | sed 's/^\s*//g' | cut -f1 -d' ') == "${servChk}.service" ]]; then
            echo -e "\033[0;33m[SKIP]\033[0m ${servChk} service is active..."
        else
            echo -e "\033[0;32m[systemctl]\033[0m starting ${servChk} system service..."
            sudo systemctl enable "${servChk}.service"
            sudo systemctl start "${servChk}.service"
        fi

    done < "${scrDir}/system_ctl.lst"
fi
