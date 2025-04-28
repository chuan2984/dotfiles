local wezterm = require("wezterm")
local module = {}

function module.apply_to_config(config)
	-- Tab bar
	config.use_fancy_tab_bar = false
	config.status_update_interval = 1000
	config.tab_bar_at_bottom = true

	wezterm.on("update-status", function(window, pane)
		-- Workspace name
		local stat = window:active_workspace()
		local stat_color = "#fcba03"
		-- It's a little silly to have workspace name all the time
		-- Utilize this to display LDR or current key table name(move_tab/resize_pane)
		if window:active_key_table() then
			stat = window:active_key_table()
			stat_color = "#7dcfff"
		end
		if window:leader_is_active() then
			stat = "LDR"
			stat_color = "#bb9af7"
		end

		local basename = function(s)
			-- Nothing a little regex can't fix
			return string.gsub(s, "(.*[/\\])(.*)", "%2")
		end

		-- Current working directory
		local cwd = pane:get_current_working_dir()
		if cwd then
			if type(cwd) == "userdata" then
				-- Wezterm introduced the URL object in 20240127-113634-bbcac864
				cwd = basename(cwd.file_path)
			else
				-- 20230712-072601-f4abf8fd or earlier version
				cwd = basename(cwd)
			end
		else
			cwd = ""
		end

		-- Current command
		local cmd = pane:get_foreground_process_name()
		-- CWD and CMD could be nil (e.g. viewing log using Ctrl-Alt-l)
		cmd = cmd and basename(cmd) or ""

		-- Time
		local time = wezterm.strftime("%H:%M")

		wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
			local function tab_title(tab_info)
				local title = tab_info.tab_title
				-- if the tab title is explicitly set, take that
				if title and #title > 0 then
					return title
				end
				-- Otherwise, use the title from the active pane
				-- in that tab
				return tab_info.active_pane.title
			end
			local title = tab_title(tab)
			local zoomed = ""
			if tab.active_pane.is_zoomed then
				zoomed = wezterm.nerdfonts.fa_expand .. " "
			end

			local divider = wezterm.nerdfonts.indent_line
			return {
				{ Text = " " .. zoomed .. title .. " " .. divider },
			}
		end)
		-- Left status (left of the tab line)
		window:set_left_status(wezterm.format({
			{ Foreground = { Color = stat_color } },
			{ Text = "  " },
			{ Text = wezterm.nerdfonts.md_duck .. "  " .. stat },
			{ Text = " |" },
		}))

		-- Right status
		window:set_right_status(wezterm.format({
			-- Wezterm has a built-in nerd fonts
			-- https://wezfurlong.org/wezterm/config/lua/wezterm/nerdfonts.html
			{ Text = wezterm.nerdfonts.md_folder .. "  " .. cwd },
			{ Text = " | " },
			{ Foreground = { Color = "#e0af68" } },
			{ Text = wezterm.nerdfonts.fa_code .. "  " .. cmd },
			"ResetAttributes",
			{ Text = " | " },
			{ Text = wezterm.nerdfonts.md_clock .. "  " .. time },
			{ Text = "  " },
		}))
	end)

	config.colors = {
		tab_bar = {
			-- The color of the strip that goes along the top of the window
			-- (does not apply when fancy tab bar is in use)
			background = "rgba(0,0,0,0)",

			-- The active tab is the one that has focus in the window
			active_tab = {
				bg_color = "rgba(0,0,0,0)",
				fg_color = "#c0c0c0",
				intensity = "Bold",
			},

			-- Inactive tabs are the tabs that do not have focus
			inactive_tab = {
				bg_color = "rgba(0,0,0,0)",
				fg_color = "#808080",
				intensity = "Half",
				-- The same options that were listed under the `active_tab` section above
				-- can also be used for `inactive_tab`.
			},

			-- You can configure some alternate styling when the mouse pointer
			-- moves over inactive tabs
			inactive_tab_hover = {
				bg_color = "#6a6fb1",
				fg_color = "#909090",
			},
		},
	}
end

return module
