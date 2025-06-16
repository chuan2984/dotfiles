local wezterm = require("wezterm")
local M = {}
local name = "DepartureMono Nerd Font"

M.init = function()
  return name
end

M.activate = function(config)
  local fallback = require("fallback_fonts").default_cjk_fallback
  local font_list = { name }
  for _, font in ipairs(fallback) do
    table.insert(font_list, font)
  end

  config.font = wezterm.font_with_fallback(font_list)
  config.font_size = 20.0
end

return M
