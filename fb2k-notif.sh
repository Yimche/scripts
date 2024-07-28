#!/bin/bash

# Author	  :	Anonymous
# Version	:	1.0
# License	:	n/a
# Date		:	2010 04/15
# Requires	:	foobar2000, foo_np_simple, notify-send
# Script Name :	fb2000_notify.sh
# Description :	Script to display Now Playing' info via 'foo_np_simple'
#				component and 'notify-send'.
#
# Notes	  :  n/a
#
# Acknowledge :  thanks to original authors
# Resources  :  n/a
#==============
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus

# -- User Constants - User can specify these variables as necessary -----------
# Location (full path) of 'foo_np_simple' file:
NPFILE='/home/julian/foobar2000/now_playing/np.txt'
# -
# Directory where you will store cover art thumbnail image used by notify-send.
# Note: using the same directory where the 'foo_np_simple' file is kept might
#	  be a good place for the thunmail.
IMGDIR='/home/julian/foobar2000/now_playing/'
#-
# Full path to alternate image (if no cover art exists).
IMGALT='/home/julian/foobar2000/default.jpg'
#-
# Specify replacement string for '&' character in message body. See function,
# 'f_fix_notify_bug', notes below.
AMPALT='And'
#-
# Strings to add to image thumbnail file. For example, if original image file
# name 'cover' (excluding extension), then new file will become
# 'cover_thumbnail', assumimg default values are used.
SEP_NAME='_'
IMGFILE_XTRA_NAME='thumbnail'
#-
# Size in pixels of thumbnail image used in 'notify-send' pop-up. This values
# is the height dimension and will automatically generate the width to maintain
# aspect ratio.
THUMB_SIZE=96
#-
# User name for controlling xhost, etc.
NOTIFUNAME='user_name'

# Also see the 'f_convert_image' function to modify image boder, filter,
# unsharp mask, etc. Make a backup copy and play around.

# -- Other Constants - DO NOT CHANGE ------------------------------------------
# Separator between file name and extension
SEP_EXT='.'
# Path separator
SEP_PATH='/'
# Extension for thumbnail image. This must be 'png' as it supports
# transparency necessary for proper display of image in notify-send pop-up.
IMGFILE_CONVERT_EXT='png'

# -- Functions ----------------------------------------------------------------
function f_get_npinfo {
  # Get 'Now Playing' info from user-specified file and set some variables
  # required by the script. The variables are assigned values based on
  # specific lines from the file:
  #  Line 1 - used for 'notify-send' message summary
  #  Line 2 to Line n-2 - used for 'notify-send' message body
  #  Line n-1 - used as the directory to search for 'Now Playing' cover art

  count=0
  while read -r line; do
    line_array[$count]="$line\n"
    let count=$count+1
  done <"$NPFILE"

  msg_line_summary=0
  let msg_lines_body=${#line_array[@]}-7
  let msg_line_dir=${#line_array[@]}-1

  msg_summary=$(echo -e "${line_array[$msg_line_summary]}")
  msg_body=$(echo -e "${line_array[@]:2:$msg_lines_body}")
  track_path=$(echo -n "${line_array[$msg_line_dir]}")

}

function f_fix_notify_bug {
  # Notify send fails to print the message body if it contains an ampersand
  # (&). It is possible there are other characters that introduce odd
  # behavior, but no others have been noted yet. Also, the same behavior did
  # not seem to apply to the message summary.

  # Remove '&'s from message body and replace with user-specified
  # alternative.
  msg_body=$(echo "$msg_body" | sed "s/&/${AMPALT}/g")

}

function f_get_image {
  # Search directory of currently playing audio file for image file. Image
  # file in this directory is assumed to be the cover art image. The image
  # will be used to create the thumbnail for the 'notify-send' pop-up.

  IFS=$''

  cover_dir=$(echo $track_path | sed -e 's/[a-zA-Z]://' -e 's/\\n//g' -e 's/\\/\//g')
  cover_dir=$(echo $cover_dir | sed -E 's/(.*)\/(.*)/\/home\/julian\1/g')

  for item in "${cover_dir}/"*; do
    if [ -f "$item" ]; then
      mime=$(file -ib "$item")
      result=$(echo $mime | grep 'image')
      if [ $result ]; then
        echo $item
        imgfile="$item"
        break
      else
        track_path=$(echo $track_path | sed -e 's/[a-zA-Z]://' -e 's/\\n//g' -e 's/\\/\//g' | sed -E 's/(.*)/\/home\/julian\1/g')
        $(ffmpeg -y -i "$track_path" -map 0:artwork? -c copy "/tmp/artwork.jpeg" >/dev/null 2>&1)
        imgfile="/tmp/artwork.jpeg"
        break
      fi
    fi
  done

  unset IFS

}

function f_convert_image {
  # Convert cover art:
  #  Step 1: create thumbnail
  #  Step 2: apply drop shadow

  if [ -n "$imgfile" ]; then
    # Resize image
    magick "$imgfile" \
      -depth 24 \
      -background transparent \
      -quality 100 \
      -filter Lanczos \
      -unsharp 0x1.5+1+0 \
      -resize ${THUMB_SIZE} \
      "$imgfile_resized" #-thumbnail x${THUMB_SIZE} \
    #-bordercolor '#000000' \
    #-border 2x2 \

    # Create drop shadow
    #magick convert "$imgfile_resized" \
    #  \( +clone -background black -shadow 60x5+10+10 \) \
    #  +swap \
    #  -background transparent \
    #  -layers merge \
    #  +repage \
    #  "$imgfile_resized"
  fi

}

function f_notify {
  # Create the 'notify-send' pop-up.

  # Set some vars
  notifuname="$NOTIFUNAME"
  namecheck=$(who | grep -E "\b${notifuname}\b")
  #notificon="user-info"
  notificon="$imgfile_resized"

  # # Set X display (needed when terminal app launches GUI app)
  # export DISPLAY=:0.0

  # # Test whether specified user is logged in
  # if [ -n "$namecheck" ]; then
  #   # Test whether X is running
  #   isx=$(xdpyinfo | head -20 | grep "X.Org")
  #   # Test whether screen has been blanked by xscreensaver
  #   if [ -n "$isx" ]; then

  #     # Add user to xhost (will be removed before script exits)
  #     # otherwise xscreensaver-command will not work properly.
  #     # [url=http://www.leidinger.net/X/xhost.html]http://www.leidinger.net/X/xhost.html[/url]
  #     xhost +nis:${notifuname}@ >/dev/null

  #     is_scrblank=$(xscreensaver-command -time 2>/dev/null | grep "screen non-blanked")

  #     # Above command issues an error message ('no saver status on
  #     # root window.') if screensaver has not been invoked since daemon
  #     # was started. Therefore, if error status (1), it means the screen
  #     # is not blanked and notifier should be issued to desktop.
  #     is_err=$?

  #     # Debug
  #     # echo $is_scrblank
  #     # echo $is_err

  #    if [ -n "$is_scrblank" ] || [ !"$is_err" ]; then
  # Send desktop notification
  notify-send \
    --icon="$notificon" \
    --expire-time=6000 \
    --urgency=normal \
    -r 3662 \
    "${msg_summary}" "${msg_body}"
  #   fi
  #   fi
  # fi

  # Remove user from xhost
  # xhost -nis:${notifuname}@ >/dev/null

}

# -- Main ---------------------------------------------------------------------
# Call functions and assign values to additional variables.

f_get_npinfo
f_fix_notify_bug
f_get_image

imgfile_base=$(basename "$imgfile")
#imgfile_base_noext="${imgfile_base%.*}"
#imgfile_thumbnail="${imgfile_base_noext}${SEP_NAME}${IMGFILE_XTRA_NAME}${SEP_EXT}${IMGFILE_CONVERT_EXT}"
#imgfile_resized="${IMGDIR}${SEP_PATH}${imgfile_thumbnail}"
imgfile_resized="${IMGDIR}${SEP_PATH}now_playing.png"

f_convert_image
f_notify

exit
