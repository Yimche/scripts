#!/bin/bash

show_notification() {
  brightness=$(brightnessctl g | awk '{printf "%d", $1/960}')
  notify-send -r 2539 -u low "Brightness: $brightness%"
}

brightness_up() {
  #brightnessctl s 5%+
  brillo -q -A 5
  show_notification 
}

brightness_down() {
  #brightnessctl s 5%-
  brillo -q -U 5
  show_notification 
}

case $1 in
  up)
    brightness_up
    ;;
  down)
    brightness_down
    ;;
esac

