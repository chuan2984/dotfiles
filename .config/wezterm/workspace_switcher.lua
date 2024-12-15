local module = {}
local wezterm = require("wezterm")

function module.apply_to_config(config)
	-- info on plugin module https://github.com/wez/wezterm/commit/e4ae8a844d8feaa43e1de34c5cc8b4f07ce525dd
	local switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
	switcher.zoxide_path = "/opt/homebrew/bin/zoxide"
	switcher.workspace_formatter = function(label)
		return wezterm.format({
			{ Attribute = { Italic = true } },
			{ Foreground = { Color = "#6cb5fb" } },
			{ Text = "󱂬: " .. label },
		})
	end

	table.insert(config.keys, { key = "b", mods = "LEADER", action = switcher.switch_to_prev_workspace() })
	table.insert(
		config.keys,
		{ key = "f", mods = "LEADER", action = switcher.switch_workspace({ extra_args = " | head -n 10" }) }
	)

	wezterm.on("augment-command-palette", function(_, _)
		return {
			{
				brief = "Window | Workspace: Switch Workspace",
				icon = "md_briefcase_arrow_up_down",
				action = switcher.switch_workspace(),
			},
			{
				brief = "Window | Workspace: Switch to Previous Workspace",
				icon = "md_briefcase_arrow_up_down",
				action = switcher.switch_to_prev_workspace(),
			},
		}
	end)
end

return module
