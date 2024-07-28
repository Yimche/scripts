#!/bin/bash

if [[ ! -z "$(pgrep foobar2000)" ]]; then
  case $1 in
  "pp")
    $(wine ~/foobar2000/foobar2000.exe /playpause)
    ;;
  "next")
    $(wine ~/foobar2000/foobar2000.exe /next)
    ;;
  "prev")
    $(wine ~/foobar2000/foobar2000.exe /prev)
    ;;
  esac
else
  case $1 in
  "pp")
    playerctl play-pause
    ;;
  "next")
    playerctl next
    ;;
  "prev")
    playerctl previous
    ;;
  esac
fi
