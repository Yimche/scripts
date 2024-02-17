#!/usr/bin/bash

PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/lib/jvm/default/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus

#Set percentage at which notifications should be sent
warn_charge=80
warn_discharge=30

battery_num=$(acpi | grep -v 'unavailable' | grep -o "Battery [0-9]" | grep -o "[0-9]")

if [[ $( acpi | grep "Battery ${battery_num}: Discharging" | wc -l) == 1 ]]; then
  current_charge=$(acpi | grep -o "Battery ${battery_num}: Discharging, [0-9]*%" | grep -o "[0-9]*%" | grep -o "[0-9]*")
  if [[ $current_charge -le $warn_discharge ]]; then
    dunstify -r 7693 -u critical "Low Battery!" "Charge is at ${current_charge} percent!"
  fi
elif [[ $( acpi | grep "Battery ${battery_num}: Charging" | wc -l) == 1 ]]; then
  current_charge=$(acpi | grep -o "Battery ${battery_num}: Charging, [0-9]*%" | grep -o "[0-9]*%" | grep -o "[0-9]*")
  if [[ $current_charge -ge $warn_charge ]]; then
    dunstify -r 7693 -u critical "Stop Charging!" "Battery is at ${current_charge} percent!"
  fi
fi
