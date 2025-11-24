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

local function can_navigate_direction(pane, direction)
  local tab = pane:tab()
  local panes = tab:panes_with_info()
  local current_pane_id = pane:pane_id()

  for _, p in ipairs(panes) do
    if p.pane:pane_id() == current_pane_id then
      if direction == "Left" and p.left > 0 then
        return true
      elseif direction == "Right" and p.left + p.width < tab:get_size().cols then
        return true
      elseif direction == "Up" and p.top > 0 then
        return true
      elseif direction == "Down" and p.top + p.height < tab:get_size().rows then
        return true
      end
      break
    end
  end
  return false
end

local function can_resize_direction(pane, direction)
  local tab = pane:tab()
  local panes = tab:panes_with_info()

  -- Need at least 2 panes to resize
  if #panes < 2 then
    return false
  end

  local current_pane_id = pane:pane_id()

  for _, p in ipairs(panes) do
    if p.pane:pane_id() == current_pane_id then
      -- For horizontal resize (Left/Right), check if there are horizontally adjacent panes
      if direction == "Left" or direction == "Right" then
        -- Check if any pane shares vertical space (horizontally adjacent)
        for _, other in ipairs(panes) do
          if other.pane:pane_id() ~= current_pane_id then
            -- Check if they overlap vertically (share horizontal border)
            if not (other.top + other.height <= p.top or other.top >= p.top + p.height) then
              return true
            end
          end
        end
      -- For vertical resize (Up/Down), check if there are vertically adjacent panes
      elseif direction == "Up" or direction == "Down" then
        -- Check if any pane shares horizontal space (vertically adjacent)
        for _, other in ipairs(panes) do
          if other.pane:pane_id() ~= current_pane_id then
            -- Check if they overlap horizontally (share vertical border)
            if not (other.left + other.width <= p.left or other.left >= p.left + p.width) then
              return true
            end
          end
        end
      end
      break
    end
  end
  return false
end

local function split_nav(resize_or_move, key)
  local move = "CTRL"
  local resize = "CTRL|META"
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
        local direction = direction_keys[key]
        local should_handle = false

        if resize_or_move == "resize" then
          should_handle = can_resize_direction(pane, direction)
        else
          should_handle = can_navigate_direction(pane, direction)
        end

        if should_handle then
          if resize_or_move == "resize" then
            win:perform_action({ AdjustPaneSize = { direction, amount } }, pane)
          else
            win:perform_action({ ActivatePaneDirection = direction }, pane)
          end
        else
          win:perform_action({
            SendKey = { key = key, mods = resize_or_move == "resize" and resize or move },
          }, pane)
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
