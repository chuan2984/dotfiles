return {
  'echasnovski/mini.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    local spec_treesitter = require('mini.ai').gen_spec.treesitter
    -- Mini AI
    require('mini.ai').setup {
      custom_textobjects = {
        F = spec_treesitter { a = '@function.outer', i = '@function.inner' },
        _ = spec_treesitter { a = '@block.outer', i = '@block.inner' },
        i = function(ai_type)
          if ai_type == 'i' then
            require('mini.indentscope').textobject(false)
          else
            require('mini.indentscope').textobject(true)
          end
        end,
      },
    }

    -- MniFiles
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
    -- Mini Surround
    require('mini.surround').setup {
      mappings = {
        add = 'gsa',
        delete = 'gsd',
        find = 'gsf',
        find_left = 'gsF',
        highlight = 'gsh',
        replace = 'gsr',
        update_n_lines = 'gsn',
      },
    }

    -- Mini StatusLine
    local statusline = require 'mini.statusline'
    statusline.setup()

    -- You can configure sections in the statusline by overriding their
    -- default behavior. For example, here we disable the section for
    -- cursor information because line numbers are already enabled

    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      return '󰞁 '
        .. require('trailblazer.trails').stacks.current_trail_mark_stack_name
        .. '['
        .. vim.tbl_count(require('trailblazer.trails.common').get_trail_mark_stack_subset_for_buf() or {})
        .. ']'
    end

    -- Function to get the number of open buffers using the :ls command
    local function get_buffer_count()
      local buffers = vim.fn.getbufinfo { buflisted = 1 }
      return #buffers
    end

    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_lsp = function()
      return ' ' .. get_buffer_count()
    end

    local bracketed = require 'mini.bracketed'
    bracketed.setup {
      file = { suffix = '' },
    }
  end,
}
-- vim: ts=2 sts=2 sw=2 et
