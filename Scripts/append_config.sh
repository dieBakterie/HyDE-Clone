#!/bin/env bash

scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/global_fn.sh"
if [ $? -ne 0 ]; then
    echo "Error: unable to source global_fn.sh..."
    exit 1
fi

CfgDir="${2:-${cloneDir}/Configs}"
inputFile="${CfgDir}/.config/hypr/nvidia.conf"
outputFile="${CfgDir}/.config/hypr/configs/environments.conf"

if [ "$(grep -c '^# █▄ █ █ █ █ █▀▄ █ ▄▀█' "${HOME}/.config/hypr/configs/environments.conf")" -eq 0 ]; then
# Entfernt die letzte leere Zeile aus der Eingabedatei und hängt den Inhalt an die Ausgabedatei an
sed '$ {/^$/d;}' "$inputFile" >> "$outputFile"

echo "Fertig! Inhalt von nvidia.conf wurde ohne zusätzliche leere Zeile zu environments.conf hinzugefügt."
fi