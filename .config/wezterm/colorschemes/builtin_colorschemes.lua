local M = {}

local colorschemes = {
  { label = "Ayu Dark", value = "Ayu Dark (Gogh)" },
  { label = "Tokyo Night Moon", value = "Tokyo Night Moon" },
  { label = "Catppuccin Mocha", value = "Catppuccin Mocha" },
  { label = "Catppuccin Macchiato", value = "Catppuccin Macchiato" },
  { label = "Oxocarbon Dark", value = "Oxocarbon Dark (Gogh)" },
  { label = "One Dark", value = "OneDark (base16)" },
}

M.init = function()
  return colorschemes
end

M.activate = function(config, _, value)
  config.color_scheme = value
end

return M
