return {
  'echasnovski/mini.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    -- MIni IndentScope
    require('mini.indentscope').setup {
      draw = {
        -- Delay (in ms) between event and start of drawing scope indicator
        delay = 100,

        -- Animation rule for scope's first drawing. A function which, given
        -- next and total step numbers, returns wait time (in ms). See
        -- |MiniIndentscope.gen_animation| for builtin options. To disable
        -- animation, use `require('mini.indentscope').gen_animation.none()`.
        animation = require('mini.indentscope').gen_animation.none(),
        priority = 2,
        mappings = {
          -- Textobjects
          object_scope = 'ii',
          object_scope_with_border = 'ai',

          -- Motions (jump to respective border line; if not present - body line)
          goto_top = '[i',
          goto_bottom = ']i',
        },
      },

      -- Options which control scope computation
      options = {
        -- Type of scope's border: which line(s) with smaller indent to
        -- categorize as border. Can be one of: 'both', 'top', 'bottom', 'none'.
        border = 'both',

        -- Whether to use cursor column when computing reference indent.
        -- Useful to see incremental scopes with horizontal cursor movements.
        indent_at_cursor = true,

        -- Whether to first check input line to be a border of adjacent scope.
        -- Use it if you want to place cursor on function header to get scope of
        -- its body.
        try_as_border = true,
      },

      -- Which character to use for drawing scope indicator
      symbol = '\u{e621}',
    }

    -- MniFiles
    local mini_files = require 'mini.files'
    mini_files.setup()

    -- Toggle open and close
    vim.keymap.set('n', '<leader>te', function()
      if not require('mini.files').close() then
        require('mini.files').open()
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

    -- Open a file in a split window
    local map_split = function(buf_id, lhs, direction)
      local rhs = function()
        -- Make new window and set it as target
        local new_target_window
        vim.api.nvim_win_call(mini_files.get_target_window(), function()
          vim.cmd(direction .. ' split')
          new_target_window = vim.api.nvim_get_current_win()
        end)

        mini_files.set_target_window(new_target_window)
      end

      local desc = 'Split ' .. direction
      vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
    end

    vim.api.nvim_create_autocmd('User', {
      pattern = 'MiniFilesBufferCreate',
      callback = function(args)
        local buf_id = args.data.buf_id
        -- Tweak keys to your liking
        map_split(buf_id, 'gs', 'Open file in belowright horizontal')
        map_split(buf_id, 'gv', 'Open file in belowright vertical')
      end,
    })

    -- Create keymap to set cwd
    local files_set_cwd = function(_)
      -- Works only if cursor is on the valid file system entry
      local cur_entry_path = mini_files.get_fs_entry().path
      local cur_directory = vim.fs.dirname(cur_entry_path)
      vim.fn.chdir(cur_directory)
    end

    vim.api.nvim_create_autocmd('User', {
      pattern = 'MiniFilesBufferCreate',
      callback = function(args)
        vim.keymap.set('n', 'g.', files_set_cwd, { buffer = args.data.buf_id })
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
      },
    }

    -- Mini AutoPairs
    require('mini.pairs').setup()

    -- Mini StatusLine
    local statusline = require 'mini.statusline'
    statusline.setup()

    -- You can configure sections in the statusline by overriding their
    -- default behavior. For example, here we disable the section for
    -- cursor information because line numbers are already enabled
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      return ''
    end

    -- Mini Notify
    local mini_notify = require 'mini.notify'
    mini_notify.setup {
      -- Content management
      content = {
        -- Function which formats the notification message
        -- By default prepends message with notification time
        format = nil,

        -- Function which orders notification array from most to least important
        -- By default orders first by level and then by update timestamp
        sort = nil,
      },
      -- Notifications about LSP progress
      lsp_progress = {
        -- Whether to enable showing
        enable = false,

        -- Duration (in ms) of how long last message should be shown
        duration_last = 1000,
      },
      -- Window options
      window = {
        -- Floating window config
        config = {},

        -- Maximum window width as share (between 0 and 1) of available columns
        max_width_share = 0.5,

        -- Value of 'winblend' option
        winblend = 20,
      },
    }

    -- Monkey patching the default vim.notify, vim.print and print
    -- to use MiniNotify so that they can be seen better and written to a history file
    vim.notify = mini_notify.make_notify {
      ERROR = { duration = 5000 },
      WARN = { duration = 4000 },
      INFO = { duration = 3000 },
    }

    if not old_print then
      _G.old_print = print
    end

    print = function(...)
      local print_safe_args = {}
      local _ = { ... }
      for i = 1, #_ do
        table.insert(print_safe_args, tostring(_[i]))
      end
      vim.notify(table.concat(print_safe_args, ' '), vim.log.levels.INFO)
    end

    vim.keymap.set('n', '<leader>sN', function()
      mini_notify.show_history()
    end, { noremap = true, silent = true, desc = 'Show Notifications' })
  end,
}
-- vim: ts=2 sts=2 sw=2 et
