#!/usr/bin/env sh

# set variables
scrDir=$(dirname "$(realpath "$0")")
source "$scrDir/globalcontrol.sh"
dstDir="${confDir}/swaync"

# regen conf
export hypr_border
envsubst < "${dstDir}/swaync.conf" > "${dstDir}/swaync.con"
envsubst < "${dstDir}/wallbash.conf" >> "${dstDir}/swaync.con"
killall swaync.con
swaync-client -rs
swaync-client -R
swaync &

#!/usr/bin/env sh

# set variables
# scrDir="$(dirname "$(realpath "$0")")"
# echo "Script directory: $scrDir"
# source "$scrDir/globalcontrol.sh"
# echo "Configuration directory: $confDir"
# dstDir="${confDir}/swaync"
# echo "Destination directory: $dstDir"

# regen conf
# export hypr_border
# envsubst < "${dstDir}/swaync.conf" > "${dstDir}/swaync.con"
# envsubst < "${dstDir}/wallbash.conf" >> "${dstDir}/swaync.con"

# Check if swaync process is running
# if pgrep -x "swaync" > /dev/null
# then
#     echo "swaync is running, killing it..."
#     killall swaync
# else
#     echo "swaync is not running"
# fi

# Restart swaync
# swaync-client -R
# swaync-client -rs
# swaync-client -sw
# swaync &