local M = {}

M.is_available = function()
  return vim.fn.filereadable 'Gemfile' == 1
end

M.tasks = {
  {
    name = 'Create Jira ticket',
    builder = function()
      local task_name = vim.fn.input 'Task name: '
      local parent = vim.fn.input 'Parent: '
      local parent_opt = ''
      if parent ~= '' then
        parent_opt = ' --parent ' .. parent
      end
      local task = {
        cmd = {
          'jira issue create -tTask -s"'
            .. task_name
            .. '"'
            .. ' -lbackend_force -b "" '
            .. parent_opt
            .. ' --component API'
            .. ' --assignee chuan',
        },
      }

      return task
    end,
  },
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
    name = 'Bring up debug containers(debug:up)',
    builder = function()
      local task = {
        cmd = { 'rake debug:up' },
      }

      return task
    end,
  },
  {
    name = 'Bring up web containers(web:up)',
    builder = function()
      local task = {
        cmd = { 'rake web:up' },
      }

      return task
    end,
  },
  {
    name = 'Down all containers',
    builder = function()
      local task = {
        cmd = { 'rake down' },
      }

      return task
    end,
  },
  {
    name = 'Restart containers with aws sso',
    builder = function()
      local task = {
        cmd = { "rake 'restart[sso]'" },
      }

      return task
    end,
  },
  {
    name = 'Restart containers',
    builder = function()
      local task = {
        cmd = { 'rake restart' },
      }

      return task
    end,
  },
  {
    name = 'Bash into container',
    builder = function()
      local task = {
        cmd = { 'rake bash' },
      }

      return task
    end,
  },
  {
    name = 'Console into container',
    builder = function()
      local task = {
        cmd = { 'rake console' },
      }

      return task
    end,
  },
  {
    name = 'Pry into container',
    builder = function()
      local task = {
        cmd = { 'rake pry' },
      }

      return task
    end,
  },
}

return M
