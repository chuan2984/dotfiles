-- sample global tasks
local M = {}

M.tasks = {
  {
    name = 'Open Daily Notes',
    builder = function()
      local task = {
        cmd = { 'cd 2ndBrain', 'nvim -c ObsidianToday' },
      }

      return task
    end,
  },
}

return M
