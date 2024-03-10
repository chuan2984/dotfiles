-- Pull in the wezterm API
require("startup")
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

local key_bind = require("key_bind")
key_bind.apply_to_config(config)
local keymaps = require("keymaps")
keymaps.apply_to_config(config)
local tabbar = require("tabbar")
tabbar.apply_to_config(config)
--local workspaces = require 'workspaces'
--
--wezterm.on('gui-startup', function()
--  workspaces.loadWorkspaces()
--end)

config.color_scheme = "tokyonight_storm"
config.font = wezterm.font_with_fallback({
	{ family = "FiraCode Nerd Font", scale = 1.5, harfbuzz_features = { "zero", "ss01", "cv05" } },
	{ family = "Fira Code", scale = 1.7 },
})
config.window_decorations = "RESIZE"
config.scrollback_lines = 3000
config.default_workspace = "work"

-- Dim inactive panes
config.inactive_pane_hsb = {
	saturation = 0.5,
	brightness = 0.7,
}

return config
