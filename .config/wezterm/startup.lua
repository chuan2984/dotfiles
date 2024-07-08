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
	local api_tab, api_tab_pane, work_wiwndow = mux.spawn_window({
		workspace = "work",
		cwd = work_dir .. "/fieldwire_api",
		args = args,
	})
	api_tab:set_title("api")
	api_tab_pane:send_text("rake full:up\n")

	-- second tab, fieldwire_api_super
	local api_super_tab, api_super_tab_pane, _ = work_wiwndow:spawn_tab({
		cwd = work_dir .. "/fieldwire_api_super",
	})
	api_super_tab:set_title("api super")
	api_super_tab_pane:send_text("make containers_start\n")
	local client_api_pane = api_super_tab_pane:split({ direction = "Right", size = 0.333 })
	client_api_pane:send_text("make dev_run_client_api_with_rails_db\n")
	local admin_api_pane = api_super_tab_pane:split({ direction = "Right", size = 0.333 })
	admin_api_pane:send_text("make dev_run_admin_api_with_rails_db\n")

	-- third tab, fieldwire_web_app
	local web_tab, web_tab_pane, _ = work_wiwndow:spawn_tab({
		cwd = work_dir .. "/fieldwire_web_app",
	})
	web_tab:set_title("web")
	web_tab_pane:send_text("yarn dev_server\n")

	-- forth tab, fieldwire_admin
	local admin_tab, admin_tab_pane, _ = work_wiwndow:spawn_tab({
		cwd = work_dir .. "/fieldwire_admin",
	})
	admin_tab:set_title("admin")
	admin_tab_pane:send_text("yarn start\n")
	-- focus first tab
	api_tab:activate()

	-- Dotfiles workspace
	-- first tab, .config dir
	local dot_tab, _, _dot_window = mux.spawn_window({
		workspace = "dotfiles",
		cwd = personal_dir,
		args = args,
	})
	dot_tab:set_title("dot")

	-- Neovim workspace
	local neovim_tab, _, _neovim_window = mux.spawn_window({
		workspace = "neovim",
		cwd = personal_dir .. "/nvim",
		args = args,
	})

	neovim_tab:set_title("neovim")

	-- Wezterm workspace
	local wez_tab, _, _wez_window = mux.spawn_window({
		workspace = "wezterm",
		cwd = personal_dir .. "/wezterm",
		args = args,
		a,
	})

	wez_tab:set_title("wez")

	-- Obsidian workspace
	local tab_six, sixth_pane, _ = mux.spawn_window({
		workspace = "obsidian",
		cwd = home .. "/github/obsidian",
		args = args,
	})
	tab_six:set_title("daily")
	sixth_pane:send_text("nv -c ObsidianToday\n")

	-- PR review workspace
	local tab_seven, seventh_pane, _ = mux.spawn_window({
		workspace = "PR review",
		cwd = work_dir,
		args = args,
	})
	tab_seven:set_title("gh dash")
	seventh_pane:send_text("gh dash\n")

	-- Start up in work workspace
	mux.set_active_workspace("work")
end)
