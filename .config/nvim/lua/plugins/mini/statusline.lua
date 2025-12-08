local M = {}

M.setup = function()
  local statusline = require 'mini.statusline'
  statusline.setup()

  -- You can configure sections in the statusline by overriding their
  -- default behavior. For example, here we disable the section for
  -- cursor information because line numbers are already enabled

  ---@diagnostic disable-next-line: duplicate-set-field
  statusline.section_location = function()
    local ok, spelunk = pcall(require, 'spelunk')
    local bookmark_icon = '󰞁 '
    if not ok then
      return bookmark_icon
    end
    local markmgr = require 'spelunk.markmgr'
    local current_stack_idx = spelunk.get_current_stack_index()
    local num_total_marks = markmgr.len_marks(current_stack_idx)
    local stack_name = markmgr.get_stack_name(current_stack_idx)
    local num_current_file_marks = spelunk.statusline():gsub('%s+', '')

    return bookmark_icon .. stack_name .. '[' .. num_current_file_marks .. '/' .. num_total_marks .. ']'
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
