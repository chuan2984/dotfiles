local wezterm = require("wezterm")
local config = wezterm.config_builder()
local mux = wezterm.mux
local act = wezterm.action

-- Load shared config from JSON (cached at startup)
local config_file = io.open(wezterm.config_dir .. "/floating_notes_config.json")
local notes_config = wezterm.json_parse(config_file:read("*a"))
config_file:close()

-- Always return the configured window title
wezterm.on("format-window-title", function()
  return notes_config.window_title
end)

-- Force "Always On Top" and position based on screen percentage
wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  local gui = window:gui_window()
  gui:perform_action(act.ToggleAlwaysOnTop, pane)

  local screen = wezterm.gui.screens().active
  local pos = notes_config.position

  -- Position: x_percent from left edge, y_percent from top
  local dims = gui:get_dimensions()
  local x = screen.x + (screen.width * pos.x_percent) - dims.pixel_width
  local y = screen.y + (screen.height * pos.y_percent)

  gui:set_position(x, y)
end)

config.default_cwd = notes_config.default_cwd
config.default_prog = notes_config.default_prog
config.initial_cols = notes_config.size.cols
config.initial_rows = notes_config.size.rows

config.window_decorations = "RESIZE"
config.window_background_opacity = 0.95
config.window_padding = { left = 0, right = 0, top = 2, bottom = 0 }
config.exit_behavior = "Close"
config.enable_tab_bar = false
config.font_size = 17

return config
