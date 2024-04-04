-- Pull in the wezterm API
require("backdrops"):set_files():random()

require("startup")
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

local keymaps = require("keymaps")
keymaps.apply_to_config(config)

local tabbar = require("tabbar")
tabbar.apply_to_config(config)

local navigator = require("navigator")
navigator.apply_to_config(config)

local workspace_switcher = require("workspace_switcher")
workspace_switcher.apply_to_config(config)

config.color_scheme = "rose-pine"
-- config.color_scheme = "tokyonight storm"

config.font = wezterm.font_with_fallback({
	{ family = "MesloLGS Nerd Font", scale = 1.5 },
	{ family = "FiraCode Nerd Font", scale = 1.5, harfbuzz_features = { "zero", "ss01", "cv05" } },
	{ family = "Fira Code", scale = 1.7 },
})

config.window_decorations = "RESIZE"
config.scrollback_lines = 3000
config.default_workspace = "work"

-- Dim inactive panes
config.inactive_pane_hsb = {
	saturation = 0.7,
	brightness = 0.8,
}

return config
