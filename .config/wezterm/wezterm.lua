require("backdrops"):set_files():random()

require("startup")
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

local keymaps = require("keymaps")
keymaps.apply_to_config(config)

local tabbar = require("tabbar")
tabbar.apply_to_config(config)

local smart_splits = require("smart-splits")
smart_splits.apply_to_config(config)

local workspace_switcher = require("workspace_switcher")
workspace_switcher.apply_to_config(config)

local resurrect = require("resurrect")
resurrect.apply_to_config(config)

config.color_scheme = "Catppuccin Macchiato"

config.font = wezterm.font_with_fallback({
	{ family = "DepartureMono Nerd Font", scale = 1.7 },
	{ family = "JetbrainsMono Nerd Font", scale = 1.7 },
	{ family = "FiraCode Nerd Font", scale = 1.7, harfbuzz_features = { "zero", "ss01", "cv05" } },
	{ family = "MesloLGS Nerd Font", scale = 1.5 },
})

config.window_decorations = "RESIZE"
config.scrollback_lines = 3000
config.default_workspace = "work"
config.enable_kitty_graphics = true
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
