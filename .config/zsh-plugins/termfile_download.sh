install_xterm_kitty_terminfo() {
  # Attempt to get terminfo for xterm-kitty
  if ! infocmp xterm-kitty &>/dev/null; then
    echo "xterm-kitty terminfo not found. Installing..."
    # Create a temp file
    tempfile=$(mktemp)
    # Download the kitty.terminfo file
    # https://github.com/kovidgoyal/kitty/blob/master/terminfo/kitty.terminfo
    if curl -o "$tempfile" https://raw.githubusercontent.com/kovidgoyal/kitty/master/terminfo/kitty.terminfo; then
      echo "Downloaded kitty.terminfo successfully."
      # Compile and install the terminfo entry for my current user
      if tic -x -o ~/.terminfo "$tempfile"; then
        echo "xterm-kitty terminfo installed successfully."
      else
        echo "Failed to compile and install xterm-kitty terminfo."
      fi
    else
      echo "Failed to download kitty.terminfo."
    fi
    # Remove the temporary file
    rm "$tempfile"
  fi
}
install_wezterm_terminfo() {
  # Attempt to get terminfo for wezterm
  if ! infocmp wezterm &>/dev/null; then
    echo "wezterm terminfo not found. Installing..."
    # Create a temp file
    tempfile=$(mktemp)
    # Download the kitty.terminfo file
    # https://github.com/kovidgoyal/kitty/blob/master/terminfo/kitty.terminfo
    if curl -o "$tempfile" https://raw.githubusercontent.com/wez/wezterm/main/termwiz/data/wezterm.terminfo; then
      echo "Downloaded wezterm.terminfo successfully."
      # Compile and install the terminfo entry for my current user
      if tic -x -o ~/.terminfo "$tempfile"; then
        echo "wezterm terminfo installed successfully."
      else
        echo "Failed to compile and install wezterm terminfo."
      fi
    else
      echo "Failed to download wezterm.terminfo."
    fi
    # Remove the temporary file
    rm "$tempfile"
  fi
}
  install_xterm_kitty_terminfo
  install_wezterm_terminfo
