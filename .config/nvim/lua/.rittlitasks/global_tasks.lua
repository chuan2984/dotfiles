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
}

return M
