# Scripts
Repo of some handy scripts I wrote

## volume-notif.sh
This is for changing your volume and sending out a notification at the same time
I recommend doing this with a keybinds e.g.
```
bindle=, XF86AudioRaiseVolume, exec, $PATH_TO_SCRIPT/volume-notif.sh up
bindle=, XF86AudioLowerVolume, exec, $PATH_TO_SCRIPT/volume-notif.sh down
bindle=, XF86AudioMute, exec, $PATH_TO_SCRIPT/volume-notif.sh mute
```

## brightness-notif.sh
This is for changing your volume and sending out a notification at the same time
I recommend doing this with a keybinds e.g.
```
binde=, XF86MonBrightnessUp, exec, $PATH_TO_SCRIPT/brightness-notif.sh up
binde=, XF86MonBrightnessDown, exec, $PATH_TO_SCRIPT/brightness-notif.sh down
```

## powercheck.sh
This is a script that I'd recommend running with cron every 5 minutes or so.
It sends out notifications to warn the user when the battery is either too low
and needs charging or too high and needs to be unplugged

## adb-monitor.sh
A script I wrote to quickly enable / disable using an android tablet as a
secondary monitor. Works on X11 and Wayland.

When using the script you need to run execute it with parameters "boot" or "kill"

## launch.sh
Custom launch scripts for files of different mime-types

## switch_audio.sh
Switches audio output when connected to bluetooth devices
