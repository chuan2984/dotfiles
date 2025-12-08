local M = {}

M.setup = function()
  local mini_files = require 'mini.files'
  mini_files.setup {
    windows = {
      preview = true,
      width_preview = 50,
      width_focus = 40,
    },
  }

  -- Toggle open and close
  vim.keymap.set('n', '<leader>te', function()
    if not require('mini.files').close() then
      require('mini.files').open(vim.api.nvim_buf_get_name(0))
    end
  end, { desc = '[T]oggle [E]xplore' })

  -- Hide and show hidden files
  local show_dotfiles = true

  local filter_show = function(_)
    return true
  end

  local filter_hide = function(fs_entry)
    return not vim.startswith(fs_entry.name, '.')
  end

  local toggle_dotfiles = function()
    show_dotfiles = not show_dotfiles
    local new_filter = show_dotfiles and filter_show or filter_hide
    mini_files.refresh { content = { filter = new_filter } }
  end

  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesBufferCreate',
    callback = function(args)
      local buf_id = args.data.buf_id
      vim.keymap.set('n', '.', toggle_dotfiles, { buffer = buf_id })
    end,
  })

  local map_split = function(buf_id, lhs, direction)
    local rhs = function()
      -- Make new window and set it as target
      local cur_target = MiniFiles.get_explorer_state().target_window
      local new_target = vim.api.nvim_win_call(cur_target, function()
        vim.cmd(direction .. ' split')
        return vim.api.nvim_get_current_win()
      end)

      MiniFiles.set_target_window(new_target)
    end

    -- Adding `desc` will result into `show_help` entries
    local desc = 'Split ' .. direction
    vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
  end

  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesBufferCreate',
    callback = function(args)
      local buf_id = args.data.buf_id
      -- Tweak keys to your liking
      map_split(buf_id, '<C-s>', 'belowright horizontal')
      map_split(buf_id, '<C-v>', 'belowright vertical')
    end,
  })

  -- Set focused directory as current working directory
  local set_cwd = function()
    local path = (MiniFiles.get_fs_entry() or {}).path
    if path == nil then
      return vim.notify 'Cursor is not on valid entry'
    end
    vim.fn.chdir(vim.fs.dirname(path))
  end

  -- Yank in register full path of entry under cursor
  local yank_path = function()
    local path = (MiniFiles.get_fs_entry() or {}).path
    if path == nil then
      return vim.notify 'Cursor is not on valid entry'
    end
    vim.fn.setreg(vim.v.register, path)
  end

  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesBufferCreate',
    callback = function(args)
      local b = args.data.buf_id
      vim.keymap.set('n', 'g~', set_cwd, { buffer = b, desc = 'Set cwd' })
      vim.keymap.set('n', 'gy', yank_path, { buffer = b, desc = 'Yank path' })
    end,
  })
end

return M
