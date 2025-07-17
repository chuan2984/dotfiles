-- sample global tasks
local M = {}

M.tasks = {
  {
    name = 'Open Daily Notes(Obsidian)',
    builder = function()
      local task = {
        cmd = { 'cd 2ndBrain', 'nvim -c "Obsidian today"' },
      }

      return task
    end,
  },
  {
    name = 'Render current d2 diagram png',
    builder = function()
      local abs_file_path = vim.fn.expand '%:p'
      local file_name = vim.fn.expand '%:t:r' .. '.png'
      local task = {
        cmd = { 'd2 ' .. abs_file_path .. ' --stdout-format=png - > ' .. file_name },
      }

      return task
    end,
  },
  {
    name = 'Watch current d2 diagram',
    builder = function()
      local abs_file_path = vim.fn.expand '%:p'
      local task = {
        cmd = { 'd2 -w --scale=1.3 ' .. abs_file_path },
      }

      return task
    end,
  },
}

return M
