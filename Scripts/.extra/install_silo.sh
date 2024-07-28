#!/usr/bin/env bash
#|---/ /+-------------------------+---/ /|#
#|--/ /-| Script to install silos |--/ /-|#
#|-/ /--| Prasanth Rangan         |-/ /--|#
#|/ /---+-------------------------+/ /---|#

baseDir=$(dirname "$(realpath "$0")")
scrDir=$(dirname "$(dirname "$(realpath "$0")")")

source "${scrDir}/global_fn.sh"
if [ $? -ne 0 ]; then
    echo "Error: unable to source global_fn.sh..."
    exit 1
fi

if ! pkg_installed silos; then
    sudo pacman -S silos
fi

silos=$(awk -F '#' '{print $1}' "${baseDir}/custom_silo.lst" | sed 's/ //g' | xargs)
sudo pacman -S "${silos}"
