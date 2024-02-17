#!/bin/bash

show_volume_notification() {
 	volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | tr -d '%')
 	muted=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
	if [ "$muted" == "yes" ]; then
    notify-send -r 2540 -u low "Volume: Muted"
  else
    notify-send -r 2540 -u low "Volume: $volume%"
  fi
}

volume_up() {
  pactl set-sink-volume @DEFAULT_SINK@ +5%
  show_volume_notification
}

volume_down() {
  pactl set-sink-volume @DEFAULT_SINK@ -5%
  show_volume_notification
}

mute() {
  pactl set-sink-mute @DEFAULT_SINK@ toggle
  show_volume_notification
}

# Subscribe to changes in the sink volume and mute status
pactl subscribe | while read -r event; do
  if echo "$event" | grep -q "sink #"; then
    show_volume_notification
  fi
done &

# Trap SIGTERM and SIGINT signals to kill the pactl subscribe process
trap "pkill -f 'pactl subscribe'" EXIT

case $1 in
  up)
    volume_up
    ;;
  down)
    volume_down
    ;;
  mute)
    mute
    ;;
esac

