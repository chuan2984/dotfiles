local wezterm = require("wezterm")
local act = wezterm.action
local module = {}

function module.apply_to_config(config)
	local function is_inside_vim(pane, robust)
		robust = robust or false

		if not robust then
			return pane:get_foreground_process_name():find("n?vim") ~= nil
		end

		local tty = pane:get_tty_name()
		if tty == nil then
			return false
		end

		local success, stdout, stderr = wezterm.run_child_process({
			"sh",
			"-c",
			"ps -o state= -o comm= -t"
				.. wezterm.shell_quote_arg(tty)
				.. " | "
				.. "grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?)(diff)?$'",
		})

		return success
	end

	local function is_outside_vim(pane)
		return not is_inside_vim(pane)
	end

	local function bind_if(cond, key, mods, action)
		local function callback(win, pane)
			if cond(pane) then
				win:perform_action(action, pane)
			else
				win:perform_action(act.SendKey({ key = key, mods = mods }), pane)
			end
		end

		return { key = key, mods = mods, action = wezterm.action_callback(callback) }
	end

	local new_bindings = {
		bind_if(is_outside_vim, "h", "CTRL", act.ActivatePaneDirection("Left")),
		bind_if(is_outside_vim, "l", "CTRL", act.ActivatePaneDirection("Right")),
		bind_if(is_outside_vim, "k", "CTRL", act.ActivatePaneDirection("Up")),
		bind_if(is_outside_vim, "j", "CTRL", act.ActivatePaneDirection("Down")),

		bind_if(is_outside_vim, "a", "ALT", act.AdjustPaneSize({ "Left", 2 })),
		bind_if(is_outside_vim, "d", "ALT", act.AdjustPaneSize({ "Right", 2 })),
		bind_if(is_outside_vim, "w", "ALT", act.AdjustPaneSize({ "Up", 2 })),
		bind_if(is_outside_vim, "s", "ALT", act.AdjustPaneSize({ "Down", 2 })),
	}

	for _, v in ipairs(new_bindings) do
		table.insert(config.keys, v)
	end
end

return module
