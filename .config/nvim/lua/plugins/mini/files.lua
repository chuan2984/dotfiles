local M = {}

M.setup = function()
  local mini_files = require 'mini.files'
  mini_files.setup {
    --  NOTE: this is overwritten by the User Command that replaces window placement
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

  -- Centering the mini files window
  --
  -- Window width based on the offset from the center, i.e. center window
  -- is 60, then next over is 20, then the rest are 10.
  -- Can use more resolution if you want like { 60, 20, 20, 10, 5 }
  --
  --                         O---------------┐
  -- *-----┐*-----┐*--------┐|               |*---------┐
  -- |     ||     ||        ||               ||         |
  -- | -3  || -2  ||   -1   ||       0       ||    1    |
  -- |     ||     ||        ||               ||         |
  -- └-----┘└-----┘└--------┘|               |└---------┘
  --                         └---------------┘
  local widths = { 40, 50, 10 }

  local ensure_center_layout = function(ev)
    local state = MiniFiles.get_explorer_state()
    if state == nil then
      return
    end

    -- Compute "depth offset" - how many windows are between this and focused
    local path_this = vim.api.nvim_buf_get_name(ev.data.buf_id):match '^minifiles://%d+/(.*)$'
    local depth_this
    for i, path in ipairs(state.branch) do
      if path == path_this then
        depth_this = i
      end
    end
    if depth_this == nil then
      return
    end
    local depth_offset = depth_this - state.depth_focus

    -- Adjust config of this event's window
    local i = math.abs(depth_offset) + 1
    local win_config = vim.api.nvim_win_get_config(ev.data.win_id)
    win_config.width = i <= #widths and widths[i] or widths[#widths]

    win_config.col = math.floor(0.5 * (vim.o.columns - widths[1]))
    for j = 1, math.abs(depth_offset) do
      local sign = depth_offset == 0 and 0 or (depth_offset > 0 and 1 or -1)
      -- widths[j+1] for the negative case because we don't want to add the center window's width
      local prev_win_width = (sign == -1 and widths[j + 1]) or widths[j] or widths[#widths]
      -- Add an extra +2 each step to account for the border width
      win_config.col = win_config.col + sign * (prev_win_width + 2)
    end

    win_config.height = depth_offset == 0 and 25 or 20
    win_config.row = math.floor(0.5 * (vim.o.lines - win_config.height))
    win_config.border = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' }
    vim.api.nvim_win_set_config(ev.data.win_id, win_config)
  end

  vim.api.nvim_create_autocmd('User', { pattern = 'MiniFilesWindowUpdate', callback = ensure_center_layout })
end

return M
