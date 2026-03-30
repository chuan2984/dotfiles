local module = {}
local wezterm = require("wezterm")

function module.apply_to_config(config)
  -- info on plugin module https://github.com/wez/wezterm/commit/e4ae8a844d8feaa43e1de34c5cc8b4f07ce525dd
  local switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
  local resurrect = wezterm.plugin.require("https://github.com/chuan2984/resurrect.wezterm")

  switcher.zoxide_path = "/opt/homebrew/bin/zoxide"

  -- Will be populated before get_workspace_elements is called
  local saved_set = {}

  -- Icons:
  --   󱂬  active + saved (filled)
  --   󰄰  active only (hollow) -- same icon, different color
  --   󰆓  saved only (not active)
  --   plain path for zoxide results
  switcher.workspace_formatter = function(label)
    local matched = label:match("([^/]+)$")
    local path_basename = matched and (matched ~= label and ".." .. matched or matched) or label
    if saved_set[label] then
      -- active AND has a saved state: filled icon
      return wezterm.format({
        { Attribute = { Italic = true } },
        { Foreground = { Color = "#6cb5fb" } },
        { Text = "󱂬 " .. path_basename },
      })
    else
      -- active only: hollow icon
      return wezterm.format({
        { Attribute = { Italic = true } },
        { Foreground = { Color = "#6cb5fb" } },
        { Text = "󰄰 " .. path_basename },
      })
    end
  end

  -- Override get_choices to include resurrect saved states and zoxide results
  switcher.get_choices = function(opts)
    local choices = {}
    local workspace_ids = {}

    -- Build saved_set first so workspace_formatter can use it
    local saved_workspace_names = resurrect.state_manager.get_saved_states("workspace")
    saved_set = {}
    for _, name in ipairs(saved_workspace_names) do
      saved_set[name] = true
    end

    -- Get currently active workspaces (formatter will use saved_set to pick icon)
    choices, workspace_ids = switcher.choices.get_workspace_elements(choices)

    -- Also register active workspaces under their ~ form so zoxide deduplication works
    for id, _ in pairs(workspace_ids) do
      local tilde = id:gsub(wezterm.home_dir, "~")
      local full = id:gsub("^~", wezterm.home_dir)
      workspace_ids[tilde] = true
      workspace_ids[full] = true
    end

    -- Add saved workspaces that aren't already active
    -- IMPORTANT: label must equal the clean workspace name (same as id).
    -- The switcher plugin calls zoxide_chosen() for any id that isn't an active
    -- workspace, and zoxide_chosen() uses `label` as the new workspace name via
    -- SwitchToWorkspace { name = label }.  If we put ANSI icons in the label the
    -- workspace gets created with a corrupted name and resurrect saves a file like
    -- "󰆓 fieldwire_api.json".  So we keep label = id = clean name here.
    for _, workspace_name in ipairs(saved_workspace_names) do
      if not workspace_ids[workspace_name] then
        table.insert(choices, {
          id = workspace_name,
          label = workspace_name,
        })
        -- Register both ~ and full path forms
        workspace_ids[workspace_name] = true
        workspace_ids[workspace_name:gsub("^~", wezterm.home_dir)] = true
      end
    end

    -- Add zoxide results, excluding already listed workspaces
    choices =
      switcher.choices.get_zoxide_elements(choices, { workspace_ids = workspace_ids, extra_args = " | head -n 4" })

    return choices
  end

  table.insert(config.keys, { key = "b", mods = "LEADER", action = switcher.switch_to_prev_workspace() })
  table.insert(config.keys, { key = "f", mods = "LEADER", action = switcher.switch_workspace() })

  wezterm.on("augment-command-palette", function(_, _)
    return {
      {
        brief = "Window | Workspace: Switch Workspace",
        icon = "md_briefcase_arrow_up_down",
        action = switcher.switch_workspace(),
      },
      {
        brief = "Window | Workspace: Switch to Previous Workspace",
        icon = "md_briefcase_arrow_up_down",
        action = switcher.switch_to_prev_workspace(),
      },
    }
  end)
end

return module
