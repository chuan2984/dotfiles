#!/bin/bash

source "$HOME/.config/yabai/scripts/find_window"

title_keyword=$1
app_keyword=$2

swap_windows() {
  local window_id=$(find_window $app_keyword $title_keyword)
  yabai -m window --swap $window_id
  echo "Swapping focused with window with id $window_id"
}

swap_windows $app_keyword $title_keyword
