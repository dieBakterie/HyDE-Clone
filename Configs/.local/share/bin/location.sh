#!/bin/env bash
# shellcheck disable=SC1091
# shellcheck disable=SC2154

# set variables
scrDir="$(dirname "$(realpath "$0")")"
source "$scrDir/globalcontrol.sh"

# define functions

cache_file="${cacheDir}/ip_cache.txt"

if [ ! -d "$(dirname "${cacheDir}")" ]; then
	mkdir -p "$(dirname "$cache_file")"
elif [ ! -f "$cache_file" ]; then
	touch "$cache_file"
fi

last_modified=$(stat -c %Y "$cache_file")
current_date=$(date +%s)
time_diff=$((current_date - last_modified))
expiry_time=86400
cached_data=$(<"$cache_file")

if [ $time_diff -lt $expiry_time ] && [ -n "$cached_data" ]; then
	echo "$cached_data"
	exit
fi

response=$(curl -s ipinfo.io 2>/dev/null | jq -r '.country + ", " + .city' 2>/dev/null)
city=$response
echo "$city" >"$cache_file"