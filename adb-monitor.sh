#!/bin/bash

if [[ "$1" == "boot" ]]; then
  if [[ $(hyprctl monitors | grep -o "HEADLESS-[0-9]" | wc -l) -lt 1 ]]; then
    hyprctl output create headless
  fi
  monitor=$(hyprctl monitors | grep -o "HEADLESS-[0-9]")
  adb reverse tcp:5900 tcp:5900
  exec ~/code_Master/vnc/wayvnc/build/wayvnc --output="$monitor"
  swww img ~/.config/wall.png
elif [[ "$1" == "kill" ]]; then
  monitor=$(hyprctl monitors | grep -o "HEADLESS-[0-9]")
  killall -q wayvnc
  hyprctl output remove "$monitor"
  killall -q waybar
  waybar
fi




#X11
#if [ "$1" == "boot" ]; then
  #xrandr --newmode "1024x768_60.00"  64.11  1024 1080 1184 1344  768 769 772 795  -HSync +Vsync
  #xrandr --addmode "DVI-I-1-1" "1024x768_60.00"
  ##xrandr --newmode "1024x768_144.00"  169.30  1024 1104 1216 1408  768 769 772 835  -HSync +Vsync
  ##xrandr --addmode "DVI-I-1-1" 1024x768_144.00
  #adb reverse tcp:5900 tcp:5900
  #x11vnc -clip 1024x768+1920+0
  #sleep 3
  #/bin/bash ~/.config/xmonad/monitors.sh &
#elif [ "$1" == "kill" ]; then
  #adb kill-server
  #xrandr --output "DVI-I-1-1" --off
  ##xrandr --delmode "HDMI-1" "1024x768_60.00"
  #xrandr --delmode "DVI-I-1-1" "1024x768_60.00"
  #xrandr --rmmode "1024x768_60.00"
  ##xrandr --rmmode "1024x768_144.00"
  #x11vnc -R stop
#fi
