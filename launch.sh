#!/bin/sh
#
# Launches files based on their mimetypes
# Usage: launch [FILE...]
# Dependencies: file

case $(file --mime-type "$@" -bL) in
  # Check for the mimetype of your file (This is POSIX regex)
  video/* | audio/* | image/gif)
    # Launch using your favorite application
    #devour mpv "$@"
    mpv "$@"
    ;;
  # So on and so forth...
  image/*)
    #devour sxiv "$@"
    sxiv "$@"
    ;;
  application/pdf | application/postscript)
    #devour zathura "$@"
    zathura "$@"
    ;;
  application/xhtml+xml | application/x-xpinstall | application/xml)
    firefox-developer-edition "$@"
    ;;
  application/vnd.openxmlformats-*)
    libreoffice "$@"
    ;;
  *) helix "$@" ;;
esac

