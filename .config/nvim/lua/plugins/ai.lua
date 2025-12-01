return {
  {
    'azorng/goose.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MeanderingProgrammer/render-markdown.nvim',
    },
    enabled = false,
    config = function()
      require('goose').setup {
        prefered_picker = 'snacks',
        default_global_keymaps = false,
        keymap = {
          global = {
            toggle = '<leader>gg', -- Open goose. Close if opened
            open_input = '<leader>ggi', -- Opens and focuses on input window on insert mode
            open_input_new_session = '<leader>ggI', -- Opens and focuses on input window on insert mode. Creates a new session
            open_output = '<leader>ggo', -- Opens and focuses on output window
            toggle_focus = '<leader>ggt', -- Toggle focus between goose and last window
            close = '<leader>ggq', -- Close UI windows
            toggle_fullscreen = '<leader>ggf', -- Toggle between normal and fullscreen mode
            select_session = '<leader>ggs', -- Select and load a goose session
            goose_mode_chat = '<leader>ggmc', -- Set goose mode to `chat`. (Tool calling disabled. No editor context besides selections)
            goose_mode_auto = '<leader>ggma', -- Set goose mode to `auto`. (Default mode with full agent capabilities)
            configure_provider = '<leader>ggp', -- Quick provider and model switch from predefined list
            diff_open = '<leader>ggd', -- Opens a diff tab of a modified file since the last goose prompt
            diff_next = '<leader>gg]', -- Navigate to next file diff
            diff_prev = '<leader>gg[', -- Navigate to previous file diff
            diff_close = '<leader>ggc', -- Close diff view tab and return to normal editing
            diff_revert_all = '<leader>ggra', -- Revert all file changes since the last goose prompt
            diff_revert_this = '<leader>ggrt', -- Revert current file changes since the last goose prompt
          },
        },
        providers = {
          -- anthropic = {
          --   'claude-3-7-sonnet-latest',
          -- },
          -- openai = {
          --   'gpt-4o-mini',
          -- },
          github_copilot = {
            'gpt-5',
            'claude-sonnet-4.5',
          },
        },
      }
    end,
  },
  {
    'NickvanDyke/opencode.nvim',
    dependencies = {
      'folke/snacks.nvim',
    },
    keys = {
      {
        '<leader>gg',
        function()
          require('opencode').ask('@this: ', { submit = true })
        end,
        mode = { 'n', 'x' },
        desc = 'Ask opencode',
      },
      {
        '<leader>gx',
        function()
          require('opencode').select()
        end,
        mode = { 'n', 'x' },
        desc = 'Execute opencode action…',
      },
      {
        '<leader>ga',
        function()
          require('opencode').prompt '@this'
        end,
        mode = { 'n', 'x' },
        desc = 'Add to opencode',
      },
      {
        '<leader>g;',
        function()
          require('opencode').toggle()
        end,
        mode = { 'n', 't' },
        desc = 'Toggle opencode',
      },
      {
        '<leader><C-u>',
        function()
          require('opencode').command 'session.half.page.up'
        end,
        mode = 'n',
        desc = 'opencode half page up',
      },
      {
        '<leader><C-d>',
        function()
          require('opencode').command 'session.half.page.down'
        end,
        mode = 'n',
        desc = 'opencode half page down',
      },
    },
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        events = {
          session_diff = {
            enabled = true,
            diff_mode = 'enhanced',
          },
        },
        provider = {
          enabled = 'wezterm',
          wezterm = {
            direction = 'right',
            percent = 40,
            top_level = false,
          },
        },
      }

      -- Required for `opts.events.reload`.
      vim.o.autoread = true
    end,
  },
}
