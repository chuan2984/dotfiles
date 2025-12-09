local wezterm = require("wezterm")
local resurrect = wezterm.plugin.require("https://github.com/chuan2984/resurrect.wezterm")
local M = {}

M.apply_to_config = function(config)
	local home = os.getenv("HOME")
	local sep = package.config:sub(1, 1)

	resurrect.state_manager.change_state_save_dir(home .. sep .. "dotfiles/.config/wezterm/")

	table.insert(config.keys, {
		key = "R",
		mods = "LEADER",
		action = wezterm.action_callback(function(win, pane)
			resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id, _)
				local type = string.match(id, "^([^/]+)") -- match before '/'
				id = string.match(id, "([^/]+)$") -- match after '/'
				id = string.match(id, "(.+)%..+$") -- remove file extention
				local opts = {
					relative = true,
					restore_text = false,
					on_pane_restore = resurrect.tab_state.default_on_pane_restore,
					close_open_tabs = true,
					window = pane:window(),
				}
				if type == "workspace" then
					local state = resurrect.state_manager.load_state(id, "workspace")
					resurrect.workspace_state.restore_workspace(state, opts)
				elseif type == "window" then
					local state = resurrect.state_manager.load_state(id, "window")
					resurrect.window_state.restore_window(pane:window(), state, opts)
				elseif type == "tab" then
					local state = resurrect.state_manager.load_state(id, "tab")
					resurrect.tab_state.restore_tab(pane:tab(), state, opts)
				end
			end)
		end),
	})

	table.insert(config.keys, {
		key = ";",
		mods = "LEADER",
		action = wezterm.action.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Renaming Current Workspace Title...:" },
			}),
			action = wezterm.action_callback(function(window, _, line)
				if line then
					local current_name = wezterm.mux.get_active_workspace()
					local mappings = resurrect.workspace_mappings
					
					-- Rename workspace
					wezterm.mux.rename_workspace(current_name, line)
					
					-- Update mapping (keeps same path, changes workspace name)
					mappings.update_workspace_name(current_name, line)
					
					-- Save state (will use path-based state ID from mapping)
					resurrect.state_manager.save_state(resurrect.workspace_state.get_workspace_state())
					
					-- NO LONGER DELETE OLD STATE - state file name doesn't change!
				end
			end),
		}),
	})

	table.insert(config.keys, {
		key = "D",
		mods = "LEADER",
		action = wezterm.action_callback(function(win, pane)
			resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id)
				resurrect.state_manager.delete_state(id)
			end, {
				title = "Delete State",
				description = "Select State to Delete and press Enter = accept, Esc = cancel, / = filter",
				fuzzy_description = "Search State to Delete: ",
				is_fuzzy = true,
			})
		end),
	})

	-- loads the state whenever I create a new workspace
	wezterm.on("smart_workspace_switcher.workspace_switcher.created", function(window, path, label)
		local workspace_state = resurrect.workspace_state
		local mappings = resurrect.workspace_mappings
		
		-- Get current workspace name (might be custom or path-based)
		local workspace_name = window:active_workspace()
		
		-- Save mapping between workspace and path
		mappings.set_mapping(workspace_name, path)
		
		-- Load state using path-based state ID
		local state_id = mappings.path_to_state_id(path)
		
		workspace_state.restore_workspace(resurrect.state_manager.load_state(state_id, "workspace"), {
			window = window,
			relative = true,
			restore_text = true,
			on_pane_restore = resurrect.tab_state.default_on_pane_restore,
			close_open_tabs = true,
		})
	end)

	wezterm.on("smart_workspace_switcher.workspace_switcher.selected", function(window, path, label)
		local workspace_state = resurrect.workspace_state
		local mappings = resurrect.workspace_mappings
		
		-- Get current workspace name
		local workspace_name = window:active_workspace()
		
		-- Update mapping if path is provided (might be switching to existing workspace)
		if path and path ~= "" then
			mappings.set_mapping(workspace_name, path)
		end
		
		-- Save state
		resurrect.state_manager.save_state(workspace_state.get_workspace_state())
	end)

	-- Periodic save and GUI startup resurrection
	resurrect.state_manager.periodic_save()
	wezterm.on("gui-startup", resurrect.state_manager.resurrect_on_gui_startup)
end

return M
