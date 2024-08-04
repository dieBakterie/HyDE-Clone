#!/bin/env bash

scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/global_fn.sh"
myNotd="dunst-git"
myIdle=""
myLock="swaylock-effects-git"

# if [[ "${myNotd}" == *-git ]]; then
#     myNotd="${myNotd%-git}"
# fi
myNotd=$(echo "${myNotd}" | sed -E 's/-.*$//')
sed "s/^\(\$notificationDaemon = \).*/\1$myNotd/" "${cloneDir}/Configs/.config/hypr/config/launchs.conf"

# if [[ "${myLock}" == *-effects-git ]]; then
#     myLock="${myLock%-effects-git}"
# elif [[ "${myLock}" == *-effects ]]; then
#     myLock="${myLock%-effects}"
# elif [[ "${myLock}" == *-git ]]; then
#     myLock="${myLock%-git}"
# fi
# myLock=$(echo "${myLock}" | sed -E 's/-(git|effects(-git)?)$//')
myLock=$(echo "${myLock}" | sed -E 's/-.*$//')
sed "s/^\(\$lockScreen = \).*/\1$myLock/" "${cloneDir}/Configs/.config/hypr/hyprland.conf"
sed "s/^\(\$lockScreen = \).*/\1$myLock/" "${cloneDir}/Configs/.config/hypr/hypridle.conf"

# if [[ "${myIdle}" == *-git ]]; then
#     myIdle="${myIdle%-git}"
# fi
myIdle=$(echo "${myIdle}" | sed -E 's/-.*$//')
sed "s/^\(\$idleManager = \).*/\1$myIdle/" "${cloneDir}/Configs/.config/hypr/config/launchs.conf"
