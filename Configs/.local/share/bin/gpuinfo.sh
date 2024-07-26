#!/usr/bin/env bash
# shellcheck disable=SC2312
# shellcheck disable=SC1090

# set variables
scrDir="$(dirname "$(realpath "$0")")"
gpuQ="/tmp/hyde-${UID}-gpuinfo-query"

tired=false
[[ " $* " =~ " tired " ]] && ! grep -q "tired" "${gpuQ}" && echo "tired=true" >>"${gpuQ}"
if [[ ! " $* " =~ " startup " ]]; then
  gpuQ="${gpuQ}$2"
fi
detect() { # auto detect GPU used by Hyprland(declared using env = WLR_DRM_DEVICES) Sophisticated?
card=$(echo "${WLR_DRM_DEVICES}" | cut -d':' -f1 | cut -d'/' -f4)
# shellcheck disable=SC2010
slot_number=$(ls -l /dev/dri/by-path/ | grep "${card}" | awk -F'pci-0000:|-card' '{print $2}')
vendor_id=$(lspci -nn -s "${slot_number}" )
declare -A vendors=(["10de"]="nvidia" ["8086"]="intel" ["1002"]="amd")
for vendor in "${!vendors[@]}"; do
   if [[ ${vendor_id} == *"${vendor}"* ]]; then
       initGPU="${vendors[${vendor}]}"
       break
   fi
done
if [[ -n "${initGPU}" ]]; then
 $0 --use "${initGPU}" startup
fi
}

query() {
 nvidia_flag=0 amd_flag=0 intel_flag=0
touch "${gpuQ}"

if lsmod | grep -q 'nouveau'; then
      echo "nvidia_gpu=\"Linux\"" >>"${gpuQ}" #? incase If nouveau is installed
      echo "nvidia_flag=1 # Using nouveau an open-source nvidia driver" >>"${gpuQ}"
elif  command -v nvidia-smi &> /dev/null; then
nvidia_gpu=$(nvidia-smi --query-gpu=gpu_name --format=csv,noheader,nounits | head -n 1)
  if [[ -n "${nvidia_gpu}" ]] ; then  # check for NVIDIA GPU
      if  [[ "${nvidia_gpu}" == *"NVIDIA-SMI has failed"* ]]; then  #? Second Layer for dGPU
        echo "nvidia_flag=0 # NVIDIA-SMI has failed" >> "${gpuQ}"
      else
        nvidia_address=$(lspci | grep -Ei "VGA|3D" | grep -i "${nvidia_gpu/NVIDIA /}" | cut -d' ' -f1)
        {   echo "nvidia_address=\"${nvidia_address}\""
            echo "nvidia_gpu=\"${nvidia_gpu/NVIDIA /}\""
            echo "nvidia_flag=1"
        } >> "${gpuQ}"
      fi
  fi
fi

if lspci -nn | grep -E "(VGA|3D)" | grep -iq "1002"; then
amd_gpu="$(lspci -nn | grep -Ei "VGA|3D" | grep -m 1 "1002" | awk -F'Advanced Micro Devices, Inc. ' '{gsub(/ *\[[^\]]*\]/,""); gsub(/ *\([^)]*\)/,""); print $2}')"
amd_address=$(lspci | grep -Ei "VGA|3D" | grep -i "${amd_gpu}" | cut -d' ' -f1)
{ echo "amd_address=\"${amd_address}\""
  echo "amd_flag=1" # check for Amd GPU
  echo "amd_gpu=\"${amd_gpu}\""
} >> "${gpuQ}";fi

if lspci -nn | grep -E "(VGA|3D)" | grep -iq "8086"; then
intel_gpu="$(lspci -nn | grep -Ei "VGA|3D" | grep -m 1 "8086" | awk -F'Intel Corporation ' '{gsub(/ *\[[^\]]*\]/,""); gsub(/ *\([^)]*\)/,""); print $2}')"
intel_address=$(lspci | grep -Ei "VGA|3D" | grep -i "${intel_gpu}" | cut -d' ' -f1)
{ echo "intel_address=\"${intel_address}\""
  echo "intel_flag=1"  # check for Intel GPU
  echo "intel_gpu=\"${intel_gpu}\""
} >>"${gpuQ}"; fi

if ! grep -q "prioGPU=" "${gpuQ}" && [[ -n "${WLR_DRM_DEVICES}" ]]; then
  trap detect EXIT
fi
}

toggle() {
  if [[ -n "$1" ]]; then
      next_prioGPU="$1_flag"
  else
    # initialize gpu_flags and prioGPU if they don't exist
    if ! grep -q "gpu_flags=" "${gpuQ}"; then
        gpu_flags=$(grep "flag=1" "${gpuQ}" | cut -d '=' -f 1 | tr '\n' ' ' | tr -d '#')
        echo "" >> "${gpuQ}"
        echo "gpu_flags=\"${gpu_flags[*]}\"" >> "${gpuQ}"
    fi

    if ! grep -q "prioGPU=" "${gpuQ}"; then
        gpu_flags=$(grep "gpu_flags=" "${gpuQ}"  | cut -d'=' -f 2)
        initGPU=$(echo "${gpu_flags}" | cut -d ' ' -f  1)
        echo "prioGPU=${initGPU}" >> "${gpuQ}"
    fi
    mapfile -t anchor < <(grep "flag=1" "${gpuQ}" | cut -d '=' -f 1)
    prioGPU=$(grep "prioGPU=" "${gpuQ}" | cut -d'=' -f 2) # get the current prioGPU from the file
    # find the index of the current prioGPU in the anchor array
    for index in "${!anchor[@]}"; do
        if [[ "${anchor[${index}]}" = "${prioGPU}" ]]; then
            current_index=${index}
        fi
    done
    next_index=$(( (current_index + 1) % ${#anchor[@]} ))
    next_prioGPU=${anchor[${next_index}]#\#}
fi

# set the next prioGPU and remove the '#' character
sed -i 's/^\(nvidia_flag=1\|amd_flag=1\|intel_flag=1\)/#\1/' "${gpuQ}" # comment out all the gpu flags in the file
sed -i "s/^#${next_prioGPU}/${next_prioGPU}/" "${gpuQ}" # uncomment the next prioGPU in the file
sed -i "s/prioGPU=${prioGPU}/prioGPU=${next_prioGPU}/" "${gpuQ}" # update the prioGPU in the file
}

# 
map_floor() {

    # read the key-value pairs into an array
    IFS=', ' read -r -a pairs <<< "$1"

    # set the default value if the last pair does not contain a colon
    if [[ ${pairs[-1]} != *":"* ]]; then
        def_val="${pairs[-1]}"
        unset 'pairs[${#pairs[@]}-1]'
    fi

    # loop through the pairs and find the highest value that is less than or equal to the given number
    for pair in "${pairs[@]}"; do
        IFS=':' read -r key value <<< "$pair"

        # check if the current pair is the highest value that is less than or equal to the given number
        if awk -v num="$2" -v k="$key" 'BEGIN { exit !(num > k) }'; then
            echo "$value"
            return
        fi
    done

    # return the default value if it exists
    [ -n "$def_val" ] && echo "$def_val" || echo " "
}

# generate emoji and icon based on temperature and utilization
get_icons() {
    # key-value pairs of temperature and utilization levels
    temp_lv="85:&🌋, 65:&🔥, 45:&☁️, &❄️"
    util_lv="90:, 60:󰓅, 30:󰾅, 󰾆"

    # return comma separated emojis/icons
    icons=$(map_floor "$temp_lv" $1 | sed "s/&/,/")
    icons="$icons,$(map_floor "$util_lv" "$2")"
    echo "$icons"
}

generate_json() {
  # get emoji and icon based on temperature and utilization
  icons=$(get_icons "$temperature" "$utilization")
  thermo=$(echo "$icons" | awk -F, '{print $1}')
  emoji=$(echo "$icons" | awk -F, '{print $2}')
  speedo=$(echo "$icons" | awk -F, '{print $3}')

  # emoji=$(get_temperature_emoji "${temperature}")
  local json="{\"text\":\"${thermo} ${temperature}°C\", \"tooltip\":\"${primary_gpu}\n${thermo} Temperature: ${temperature}°C ${emoji}"
  #? soon add Something incase needed.
  declare -A tooltip_parts
  if [[ -n "${utilization}" ]]; then tooltip_parts["\n$speedo Utilization: "]="${utilization}%" ; fi
  if [[ -n "${current_clock_speed}" ]] && [[ -n "${max_clock_speed}" ]]; then tooltip_parts["\n Clock Speed: "]="${current_clock_speed}/${max_clock_speed} MHz" ; fi
  if [[ -n "${gpu_load}" ]]; then tooltip_parts["\n$speedo Utilization: "]="${gpu_load}%" ; fi
  if [[ -n "${core_clock}" ]]; then tooltip_parts["\n Clock Speed: "]="${core_clock} MHz" ;fi
  if [[ -n "${power_usage}" ]]; then if [[ -n "${power_limit}" ]]; then
                                    tooltip_parts["\n󱪉 Power Usage: "]="${power_usage}/${power_limit} W"
                                  else
                                    tooltip_parts["\n󱪉 Power Usage: "]="${power_usage} W"
                                  fi
  fi
  if [[ -n "${power_discharge}" ]] && [[ "${power_discharge}" != "0" ]]; then tooltip_parts["\n Power Discharge: "]="${power_discharge} W" ;fi

  for key in "${!tooltip_parts[@]}"; do
    local value="${tooltip_parts[${key}]}"
    if [[ -n "${value}" && "${value}" =~ [a-zA-Z0-9] ]]; then
      json+="${key}${value}"
    fi
  done
  json="${json}\"}"
  echo "${json}"
}

general_query() { # function to get temperature from 'sensors'
	filter=''
temperature=$(sensors | ${filter} grep -m 1 -E "(edge|Package id.*|another keyword)" | awk -F ':' '{print int($2)}') #! we can get json data from sensors too
  # gpu_load=$()
  # core_clock=$()
for file in /sys/class/power_supply/BAT*/power_now; do
    [[ -f "${file}" ]] && power_discharge=$(awk '{print $1*10^-6 ""}' "${file}") && break
done
[[ -z "${power_discharge}" ]] && for file in /sys/class/power_supply/BAT*/current_now; do
    [[ -e "${file}" ]] && power_discharge=$(awk -v current="$(cat "${file}")" -v voltage="$(cat "${file/current_now/voltage_now}")" 'BEGIN {print (current * voltage) / 10^12 ""}') && break
done
# power_limit=$()
utilization=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1" "}')
current_clock_speed=$(awk '{sum += $1; n++} END {if (n > 0) print sum / n / 1000 ""}' /sys/devices/system/cpu/cpufreq/policy*/scaling_cur_freq)
max_clock_speed=$(awk '{print $1/1000}' /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq)
}

intel_GPU() { #? function to query basic intel GPU
    primary_gpu="Intel ${intel_gpu}"
    general_query
}

nvidia_GPU() { #? function to query Nvidia GPU
    primary_gpu="NVIDIA ${nvidia_gpu}"
  if [[ "${nvidia_gpu}" == "Linux" ]]; then general_query ; return ; fi #? open source driver
#? tired Flag for not using nvidia-smi if GPU is in suspend mode.
if ${tired}; then is_suspend="$(cat /sys/bus/pci/devices/0000:"${nvidia_address}"/power/runtime_status)"
   if [[ ${is_suspend} == *"suspend"* ]]; then
      printf '{"text":"󰤂", "tooltip":"%s ⏾ Suspended mode"}' "${primary_gpu}"; exit ;fi
fi
  gpu_info=$(nvidia-smi --query-gpu=temperature.gpu,utilization.gpu,clocks.current.graphics,clocks.max.graphics,power.draw,power.limit --format=csv,noheader,nounits)
  # split the comma-separated values into an array
  IFS=',' read -ra gpu_data <<< "${gpu_info}"
  # extract individual values
  temperature="${gpu_data[0]// /}"
  utilization="${gpu_data[1]// /}"
  current_clock_speed="${gpu_data[2]// /}"
  max_clock_speed="${gpu_data[3]// /}"
  power_usage="${gpu_data[4]// /}"
  power_limit="${gpu_data[5]// /}"
}

amd_GPU() { #? function to query amd GPU
  primary_gpu="AMD ${amd_gpu}"
  # execute the AMD GPU Python script and use its output
  amd_output=$(python3 "${scrDir}/amdgpu.py")
if [[ ! ${amd_output} == *"No AMD GPUs detected."* ]] && [[ ! ${amd_output} == *"Unknown query failure"* ]]; then
  # extract GPU Temperature, GPU Load, GPU Core Clock, and GPU Power Usage from amd_output
  temperature=$(echo "${amd_output}" | jq -r '.["GPU Temperature"]' | sed 's/°C//')
  gpu_load=$(echo "${amd_output}" | jq -r '.["GPU Load"]' | sed 's/%//')
  core_clock=$(echo "${amd_output}" | jq -r '.["GPU Core Clock"]' | sed 's/ GHz//;s/ MHz//')
  power_usage=$(echo "${amd_output}" | jq -r '.["GPU Power Usage"]' | sed 's/ Watts//')
else
general_query
fi
}

if [[ ! -f "${gpuQ}" ]]; then
query ; echo -e "Initialized Variable:\n$(cat "${gpuQ}")\n\nReboot or '$0 --reset' to RESET Variables"
fi
source "${gpuQ}"
case "$1" in
  "--toggle"|"-t")
      toggle
echo -e "Sensor: ${next_prioGPU} GPU" | sed 's/_flag//g'
 exit
    ;;
  "--use"|"-u")
      toggle "$2"
    ;;
  "--reset"|"-rf")
    rm -fr "${gpuQ}"*
    query
    echo -e "Initialized Variable:\n$(cat "${gpuQ}" || true)\n\nReboot or '$0 --reset' to RESET Variables"
    exit
    ;;
  *"-"*)
gpu_flags=$(grep "flag=1" "${gpuQ}" | cut -d '=' -f 1 | tr '\n' ' ' | tr -d '#')
cat << EOF

Avialable GPU: ${gpu_flags//_flag/}
[options]
--toggle         * Toggle available GPU
--use [GPU]      * Only call the specified GPU (Useful for adding specific GPU on waybar)
--reset          * Remove & restart all query

[flags]
tired            * Adding this option will not query nvidia-smi if gpu is in suspend mode
startup          * Useful if you want a certain GPU to be set at startup

* If ${USER} declared env = WLR_DRM_DEVICES on hyprland then use this as the primary GPU
EOF
exit
    ;;
esac

nvidia_flag=${nvidia_flag:-0} intel_flag=${intel_flag:-0} amd_flag=${amd_flag:-0}
#? based on the flags, call the corresponding function multi flags means multi GPU.
if [[ "${nvidia_flag}" -eq 1 ]]; then
  nvidia_GPU
elif [[ "${amd_flag}" -eq 1 ]]; then
  amd_GPU
elif [[ "${intel_flag}" -eq 1 ]]; then
  intel_GPU
else primary_gpu="Not found"
  general_query
fi

generate_json #? autoGen the Json txt for Waybar