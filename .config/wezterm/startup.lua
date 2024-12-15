local wezterm = require("wezterm")
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
local mux = wezterm.mux
local workspace_state = resurrect.workspace_state

wezterm.on("gui-startup", function(cmd)
	local args = {}
	if cmd then
		args = cmd.args
	end

	wezterm.plugin.update_all()

	local home = wezterm.home_dir
	local work_dir = home .. "/github/work"
	local personal_dir = home .. "/dotfiles/.config"

	-- TODO: check all files in the workspace folder and iterate over to restore all saved states

	-- Work workspace
	local work_ws_name = "work"
	local _, _, work_wiwndow = mux.spawn_window({
		workspace = work_ws_name,
		cwd = work_dir .. "/fieldwire_api",
		args = args,
	})
	mux.set_active_workspace(work_ws_name)
	workspace_state.restore_workspace(resurrect.load_state(work_ws_name, "workspace"), {
		window = work_wiwndow,
		relative = true,
		restore_text = true,
		on_pane_restore = resurrect.tab_state.default_on_pane_restore,
	})

	-- Dotfiles workspace
	local dot_ws_name = "dotfiles"
	local _, _, dot_window = mux.spawn_window({
		workspace = dot_ws_name,
		cwd = personal_dir,
		args = args,
	})
	mux.set_active_workspace(dot_ws_name)
	workspace_state.restore_workspace(resurrect.load_state(dot_ws_name, "workspace"), {
		window = dot_window,
		relative = true,
		restore_text = true,
		on_pane_restore = resurrect.tab_state.default_on_pane_restore,
	})

	-- Neovim workspace
	local nvim_ws_name = "neovim"
	local _, _, neovim_window = mux.spawn_window({
		workspace = nvim_ws_name,
		cwd = personal_dir .. "/nvim",
		args = args,
	})
	mux.set_active_workspace(nvim_ws_name)
	workspace_state.restore_workspace(resurrect.load_state(nvim_ws_name, "workspace"), {
		window = neovim_window,
		relative = true,
		restore_text = true,
		on_pane_restore = resurrect.tab_state.default_on_pane_restore,
	})

	-- Wezterm workspace
	local wez_ws_name = "wezterm"
	local _, _, wez_window = mux.spawn_window({
		workspace = wez_ws_name,
		cwd = personal_dir .. "/wezterm",
		args = args,
	})
	mux.set_active_workspace(wez_ws_name)
	workspace_state.restore_workspace(resurrect.load_state(wez_ws_name, "workspace"), {
		window = wez_window,
		relative = true,
		restore_text = true,
		on_pane_restore = resurrect.tab_state.default_on_pane_restore,
	})

	-- Obsidian workspace
	local obsidian_ws_name = "obsidian"
	local _, _, obsidian_window = mux.spawn_window({
		workspace = obsidian_ws_name,
		cwd = home .. "/github/obsidian",
		args = args,
	})
	mux.set_active_workspace(obsidian_ws_name)
	workspace_state.restore_workspace(resurrect.load_state(obsidian_ws_name, "workspace"), {
		window = obsidian_window,
		relative = true,
		restore_text = true,
		on_pane_restore = resurrect.tab_state.default_on_pane_restore,
	})

	-- PR review workspace
	local pr_ws_name = "PR review"
	local _, _, pr_review_window = mux.spawn_window({
		workspace = pr_ws_name,
		cwd = work_dir,
		args = args,
	})
	mux.set_active_workspace(pr_ws_name)
	workspace_state.restore_workspace(resurrect.load_state(pr_ws_name, "workspace"), {
		window = pr_review_window,
		relative = true,
		restore_text = true,
		on_pane_restore = resurrect.tab_state.default_on_pane_restore,
	})

	mux.set_active_workspace("work")
end)
