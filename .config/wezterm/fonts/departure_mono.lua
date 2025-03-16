local wezterm = require("wezterm")
local M = {}
local name = "DepartureMono Nerd Font"

M.init = function()
	return name
end

M.activate = function(config)
	config.font = wezterm.font(name)
	config.font_size = 20.0
end

return M
