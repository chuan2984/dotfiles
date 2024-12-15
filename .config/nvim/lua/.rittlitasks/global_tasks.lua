-- sample global tasks
local M = {}

M.tasks = {
  {
    name = 'List all the files and print Hello!',
    builder = function()
      local task = {
        cmd = { 'ls -la', 'echo $greeting' },
        env = { greeting = 'Hello' },
      }

      return task
    end,
  },
  {
    name = 'Build and Run current CPP or C file with Args',
    builder = function(cache)
      vim.cmd 'wa'
      if vim.fn.isdirectory 'build' == 0 then
        vim.fn.mkdir 'build'
      end

      local task = {}
      local cur_file = vim.fn.expand '%'
      local bin_name = vim.fn.fnamemodify(cur_file, ':t:r')
      local compiler = vim.bo.filetype == 'c' and 'gcc' or 'g++'
      if not cache.args then
        cache.args = vim.fn.input { prompt = 'Enter exe arguments: ' }
      end

      task.cmd = {
        string.format('%s %s -o build/%s', compiler, cur_file, bin_name),
        string.format('./build/%s %s', bin_name, cache.args),
      }
      return task
    end,
  },
}

return M
