---@type Wezterm
local wezterm = require("wezterm")

---@type Action
local act = wezterm.action
local balance = require("balance")
local backdrops = require("backdrops")

local module = {}

function module.apply_to_config(config)
  config.leader = { key = "m", mods = "CTRL", timeout_milliseconds = 1000 }
  config.keys = {
    -- only send C-b once when C-b is pressed twice
    { key = "m", mods = "LEADER|CTRL", action = act.SendKey({ key = "m", mods = "CTRL" }) },
    { key = "c", mods = "LEADER", action = act.ActivateCopyMode },
    { key = "'", mods = "LEADER", action = act.QuickSelect },
    { key = "phys:Space", mods = "LEADER", action = act.ActivateCommandPalette },

    -- Pane keybindings
    { key = "UpArrow", mods = "SHIFT", action = act.ScrollByPage(-4) },
    { key = "DownArrow", mods = "SHIFT", action = act.ScrollByPage(4) },
    {
      key = "/",
      mods = "LEADER",
      action = wezterm.action.Search({ CaseSensitiveString = "" }),
    },
    {
      key = "f",
      mods = "CTRL|SHIFT",
      action = wezterm.action.DisableDefaultAssignment,
    },
    { key = "s", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "v", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
    { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
    { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
    { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
    { key = "q", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
    { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
    { key = "o", mods = "LEADER", action = act.RotatePanes("Clockwise") },
    { key = "i", mods = "LEADER", action = act.PaneSelect({ show_pane_ids = true }) },
    {
      key = "=",
      mods = "LEADER",
      action = act.Multiple({
        wezterm.action_callback(balance.balance_panes("x")),
        wezterm.action_callback(balance.balance_panes("y")),
      }),
    },
    -- We can make separate keybindings for resizing panes
    -- But Wezterm offers custom "mode" in the name of "KeyTable"
    -- use 'enter' to confirm
    {
      key = "r",
      mods = "LEADER",
      action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }),
    },

    -- Tab keybindings
    { key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
    { key = "[", mods = "LEADER", action = act.ActivateTabRelative(-1) },
    { key = "]", mods = "LEADER", action = act.ActivateTabRelative(1) },
    { key = "n", mods = "LEADER", action = act.ShowTabNavigator },
    {
      key = "e",
      mods = "LEADER",
      action = act.PromptInputLine({
        description = wezterm.format({
          { Attribute = { Intensity = "Bold" } },
          { Foreground = { AnsiColor = "Fuchsia" } },
          { Text = "Renaming Tab Title...:" },
        }),
        action = wezterm.action_callback(function(window, pane, line)
          if line then
            window:active_tab():set_title(line)
          end
        end),
      }),
    },
    -- Key table for moving tabs around
    { key = "m", mods = "LEADER", action = act.ActivateKeyTable({ name = "move_tab", one_shot = false }) },

    -- Lastly, workspace
    {
      key = "w",
      mods = "LEADER",
      action = act.ShowLauncherArgs({ flags = "WORKSPACES", title = "workspaces" }),
    },

    -- background controls --
    {
      key = "_",
      mods = "LEADER",
      action = wezterm.action_callback(function(window, _pane)
        backdrops:random(window)
      end),
    },
    {
      key = [[,]],
      mods = "LEADER",
      action = wezterm.action_callback(function(window, _pane)
        backdrops:cycle_back(window)
      end),
    },
    {
      key = [[.]],
      mods = "LEADER",
      action = wezterm.action_callback(function(window, _pane)
        backdrops:cycle_forward(window)
      end),
    },
    {
      key = [[\]],
      mods = "LEADER",
      action = act.InputSelector({
        title = "Select Background",
        choices = backdrops:choices(),
        fuzzy = true,
        fuzzy_description = "Select Background: ",
        action = wezterm.action_callback(function(window, _pane, idx)
          ---@diagnostic disable-next-line: param-type-mismatch
          backdrops:set_img(window, tonumber(idx))
        end),
      }),
    },
  }

  -- I can use the tab navigator (LDR t), but I also want to quickly navigate tabs with index
  for i = 1, 9 do
    table.insert(config.keys, {
      key = tostring(i),
      mods = "LEADER",
      action = act.ActivateTab(i - 1),
    })
  end

  config.key_tables = {
    resize_pane = {
      { key = "h", action = act.AdjustPaneSize({ "Left", 10 }) },
      { key = "j", action = act.AdjustPaneSize({ "Down", 10 }) },
      { key = "k", action = act.AdjustPaneSize({ "Up", 10 }) },
      { key = "l", action = act.AdjustPaneSize({ "Right", 10 }) },
      { key = "Escape", action = "PopKeyTable" },
      { key = "Enter", action = "PopKeyTable" },
    },
    move_tab = {
      { key = "h", action = act.MoveTabRelative(-1) },
      { key = "j", action = act.MoveTabRelative(-1) },
      { key = "k", action = act.MoveTabRelative(1) },
      { key = "l", action = act.MoveTabRelative(1) },
      { key = "Escape", action = "PopKeyTable" },
      { key = "Enter", action = "PopKeyTable" },
    },
  }
end

return module
