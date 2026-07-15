local M = {}

M.setup = function()
  local statusline = require 'mini.statusline'
  statusline.setup()

  -- You can configure sections in the statusline by overriding their
  -- default behavior. For example, here we disable the section for
  -- cursor information because line numbers are already enabled

  ---@diagnostic disable-next-line: duplicate-set-field
  statusline.section_location = function()
    return require('opencode').statusline()
  end

  -- Function to get the number of open buffers using the :ls command
  local function get_buffer_count()
    local buffers = vim.fn.getbufinfo { buflisted = 1 }
    return #buffers
  end

  ---@diagnostic disable-next-line: duplicate-set-field
  statusline.section_lsp = function()
    return ' ' .. get_buffer_count()
  end
end

return M
