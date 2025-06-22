#!/bin/bash
IFS=$'\n'

active_monitor=$(hyprctl activeworkspace | awk '{print $7}' | sed -r '/^\s*$/d' | sed 's/\://g')
inactive_monitors=($(grep "wallpaper = " ~/.config/hypr/hyprpaper.conf | grep -v "${active_monitor}"))

active_paper=$1
config_file=~/.config/hypr/hyprpaper.conf

#if [[ -z "$active_paper" ]]; then
#  echo "Usage: $0 <path-to-active-wallpaper>"
#  exit 1
#fi

hyprpaper_proc=$(pgrep -x "hyprpaper")
if [[ ${hyprpaper_proc} -gt 0 ]]; then
  echo -n "Killed\n"
  killall -9 hyprpaper
fi

# Remove old config file
rm -f "${config_file}"
echo "preload = ${active_paper}" >>"${config_file}"
echo "wallpaper = ${active_monitor},${active_paper}" >>"${config_file}"

# Iterate over inactive monitors and set preloaded wallpapers
for monitor in "${inactive_monitors[@]}"; do
  #echo "${monitor}"
  inactive_paper=$(echo "${monitor}" | awk -F ',' '{print $2}')
  if [[ -z "${inactive_paper}" ]]; then
    inactive_paper="${active_paper}" # Fallback if no old config exists
  fi
  echo "preload = ${inactive_paper}" >>"${config_file}"
  echo "${monitor}" >>"${config_file}"
done

# Restart hyprpaper with new config
nohup hyprpaper >/dev/null 2>&1 &
disown
exit 1
