#!/bin/bash

source "$HOME/.config/yabai/scripts/find_window"

app_keyword=$1
title_keyword=$2

stack_window() {
  local window_id=$(find_window $app_keyword $title_keyword)
  yabai -m window --stack $window_id
  yabai -m window --focus $window_id
  echo "stacking window with id \"$window_id\" on top of current"
}

stack_window $app_keyword $title_keyword

