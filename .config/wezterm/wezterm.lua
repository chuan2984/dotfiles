require("backdrops"):set_files():random()

require("startup")
---@type Wezterm
local wezterm = require("wezterm")
---@type Config
local config = wezterm.config_builder()

local keymaps = require("keymaps")
keymaps.apply_to_config(config)

local config_setup = require("config_setup")
config_setup.apply_to_config(config)

local tabbar = require("tabbar")
tabbar.apply_to_config(config)

local smart_splits = require("smart-splits")
smart_splits.apply_to_config(config)

local workspace_switcher = require("workspace_switcher")
workspace_switcher.apply_to_config(config)

local resurrect = require("resurrect")
resurrect.apply_to_config(config)

local toggle_terminal = wezterm.plugin.require("https://github.com/zsh-sage/toggle_terminal.wez")
toggle_terminal.apply_to_config(config)

config.window_decorations = "RESIZE"
config.scrollback_lines = 3000
config.max_fps = 240
config.text_background_opacity = 0.5

config.set_environment_variables = {
  TERMINFO_DIRS = os.getenv("HOME") .. "/.terminfo",
}
config.term = "xterm-kitty"

-- Dim inactive panes
config.inactive_pane_hsb = {
  saturation = 0.5,
  brightness = 0.6,
}

return config
