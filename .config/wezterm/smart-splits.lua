local wezterm = require("wezterm")
local module = {}

local function is_vim(pane)
	return pane:get_user_vars().IS_NVIM == "true"
end

local direction_keys = {
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local function split_nav(resize_or_move, key)
	local move = 'CTRL'
	local resize = 'CTRL|META'
	local amount = 10

	return {
		key = key,
		mods = resize_or_move == "resize" and resize or move,
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				-- pass the keys through to vim/nvim
				win:perform_action({
					SendKey = { key = key, mods = resize_or_move == "resize" and resize or move },
				}, pane)
			else
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], amount } }, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
end

function module.apply_to_config(config)
	local keys = {
		-- move between split panes
		split_nav("move", "h"),
		split_nav("move", "j"),
		split_nav("move", "k"),
		split_nav("move", "l"),
		-- resize panes
		split_nav("resize", "h"),
		split_nav("resize", "j"),
		split_nav("resize", "k"),
		split_nav("resize", "l"),
	}

	for _, key in ipairs(keys) do
		table.insert(config.keys, key)
	end
end

return module


