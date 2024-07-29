local module = {}
local wezterm = require("wezterm")

function module.apply_to_config(config)
	local switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
	switcher.set_zoxide_path("/opt/homebrew/bin/zoxide")
	switcher.set_workspace_formatter(function(label)
		return wezterm.format({
			{ Attribute = { Italic = true } },
			{ Foreground = { Color = "teal" } },
			-- { Background = { Color = "rgba(0, 0, 1, 0.5)" } },
			{ Text = "󱂬: " .. label },
		})
	end)

	table.insert(config.keys, { key = "f", mods = "LEADER", action = switcher.switch_workspace(" | head -n 10") })
end

return module
