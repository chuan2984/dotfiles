-- Defines config selector that allows you to change font, color scheme, size, line height dynamically
-- @see https://github.com/wezterm/wezterm/discussions/5435 or https://github.com/pkazmier/wezterm-config/blob/main/config-selector.lua
local selector = require("config_selector")
local module = {}

function module.apply_to_config(config)
	local fonts = selector.new({ title = "Font Selector", subdir = "fonts" })
	local leading = selector.new({ title = "Font Leading Selector", subdir = "leadings" })
	local schemes = selector.new({ title = "Color Scheme Selector", subdir = "colorschemes" })
	local sizes = selector.new({ title = "Font Size Selector", subdir = "sizes" })

	fonts:select(config, "JetbrainsMono Nerd Font")
	schemes:select(config, "Catppuccin Macchiato")

	local new_keys = {
		{ key = "C", mods = "LEADER", action = schemes:selector_action() },
		{ key = "F", mods = "LEADER", action = fonts:selector_action() },
		{ key = "L", mods = "LEADER", action = leading:selector_action() },
		{ key = "S", mods = "LEADER", action = sizes:selector_action() },
	}

	for _, key_binding in ipairs(new_keys) do
		table.insert(config.keys, key_binding)
	end
end

return module
