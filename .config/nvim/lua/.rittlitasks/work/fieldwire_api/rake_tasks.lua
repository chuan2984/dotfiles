local M = {}

M.is_available = function()
  return vim.fn.filereadable 'Gemfile' == 1
end

M.tasks = {
  {
    name = 'Bring up all containers(full:up)',
    builder = function()
      local task = {
        cmd = { 'rake full:up' },
      }

      return task
    end,
  },
  {
    name = 'Down all containers',
    builder = function()
      local task = {
        cmd = { 'docker compose down --remove-orphans' },
      }

      return task
    end,
  },
  {
    name = 'Restart containers with aws sso',
    builder = function()
      local task = {
        cmd = { "rake 'full:restart[sso]'" },
      }

      return task
    end,
  },
  {
    name = 'Bash into full(full:b)',
    builder = function()
      local task = {
        cmd = { 'rake full:b' },
      }

      return task
    end,
  },
  {
    name = 'Console into full(full:c)',
    builder = function()
      local task = {
        cmd = { 'rake full:c' },
      }

      return task
    end,
  },
}

return M
