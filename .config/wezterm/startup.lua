local wezterm = require("wezterm")
local mux = wezterm.mux

wezterm.on("gui-startup", function(cmd)
	local args = {}
	if cmd then
		args = cmd.args
	end

	local home = wezterm.home_dir
	local work_dir = home .. "/github/work"
	local personal_dir = home .. "/dotfiles/.config"

	-- Work workspace
	-- first tab, fieldwire_api
	local tab_one, pane_one, first_window = mux.spawn_window({
		workspace = "work",
		cwd = work_dir .. "/fieldwire_api",
		args = args,
	})
	tab_one:set_title("api")
	pane_one:send_text("rake web:up\n")

	-- second tab, fieldwire_web_app
	local tab_two, second_pane, _ = first_window:spawn_tab({
		cwd = work_dir .. "/fieldwire_web_app",
	})
	tab_two:set_title("web_app")
	second_pane:send_text("yarn dev_server\n")
	-- focus first tab
	tab_one:activate()

	-- Dotfiles workspace
	-- first tab, .config dir
	local tab_three, pane, sec_window = mux.spawn_window({
		workspace = "dotfiles",
		cwd = personal_dir,
		args = args,
	})
	tab_three:set_title("dot")

	-- second tab, nvim
	local tab_four, forth_pane, _ = sec_window:spawn_tab({
		cwd = personal_dir .. "/nvim",
	})
	tab_four:set_title("nvim")
	forth_pane:send_text("nv\n")

	-- third tab, wezterm
	local tab_five, fifth_pane, _ = sec_window:spawn_tab({
		cwd = personal_dir .. "/wezterm",
	})
	tab_five:set_title("wez")
	fifth_pane:send_text("nv\n")
	-- focus first tab
	tab_three:activate()

	-- Obsidian workspace
	local tab_six, sixth_pane, _third_window = mux.spawn_window({
		workspace = "obsidian",
		cwd = home .. "/github/obsidian",
		args = args,
	})
	tab_six:set_title("daily")
	sixth_pane:send_text("nv -c ObsidianToday\n")

	-- PR review workspace
	local tab_seven, seventh_pane, _forth_window = mux.spawn_window({
		workspace = "PR review",
		cwd = work_dir,
		args = args,
	})
	tab_seven:set_title("gh dash")
	seventh_pane:send_text("gh dash\n")

	-- We want to startup in the coding workspace
	mux.set_active_workspace("work")
end)
