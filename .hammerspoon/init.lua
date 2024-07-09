require("hs.ipc") -- to be able to use cli
hs.ipc.cliInstall("/opt/homebrew")

hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall:andUse("EmmyLua") -- for lua lsp

local stackline = require("stackline")
stackline:init({
	paths = {
		yabai = "/opt/homebrew/bin/yabai",
	},
	-- NOTE: due to a bug in the source code, all options of a hash need to be specified
	appearance = {
		size = 50,
		offset = {
			y = 2,
			x = 6,
		},
		showIcons = false,
		alpha = 1,
		color = { white = 0.9 },
		dimmer = 2.5,
		fadeDuration = 0.2,
		iconDimmer = 1.1,
		iconPadding = 4,
		pillThinness = 6,
		radius = 3,
		shouldFade = true,
		vertSpacing = 1.2,
	},
})

-- bind alt+ctrl+t to toggle stackline icons
hs.hotkey.bind({ "alt", "ctrl" }, "t", function()
	stackline.config:toggle("appearance.showIcons")
end)
