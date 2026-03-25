return {
  {
    'NickvanDyke/opencode.nvim',
    lazy = false,
    dependencies = {
      'folke/snacks.nvim',
    },
    keys = {
      {
        '<c-g>g',
        function()
          require('opencode').ask('@this: ', { submit = true })
        end,
        mode = { 'n', 'x' },
        desc = 'Ask opencode',
      },
      {
        '<c-g>x',
        function()
          require('opencode').select()
        end,
        mode = { 'n', 'x' },
        desc = 'Execute opencode action…',
      },
      {
        '<c-g>a',
        function()
          require('opencode').prompt '@this'
        end,
        mode = { 'n', 'x' },
        desc = 'Add to opencode',
      },
      {
        '<c-g>;',
        function()
          require('opencode').toggle()
        end,
        mode = { 'n', 't' },
        desc = 'Toggle opencode',
      },
      {
        '<c-g><C-u>',
        function()
          require('opencode').command 'session.half.page.up'
        end,
        mode = 'n',
        desc = 'opencode half page up',
      },
      {
        '<c-g><C-d>',
        function()
          require('opencode').command 'session.half.page.down'
        end,
        mode = 'n',
        desc = 'opencode half page down',
      },
    },
    config = function()
      local opencode_cmd = 'opencode --port'
      ---@type snacks.terminal.Opts
      local snacks_terminal_opts = {
        win = {
          position = 'right',
          enter = false,
          on_win = function(win)
            require('opencode.terminal').setup(win.win)
          end,
        },
      }
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        server = {
          start = function()
            require('snacks.terminal').open(opencode_cmd, snacks_terminal_opts)
          end,
          stop = function()
            require('snacks.terminal').get(opencode_cmd, snacks_terminal_opts):close()
          end,
          toggle = function()
            require('snacks.terminal').toggle(opencode_cmd, snacks_terminal_opts)
          end,
        },
        -- lsp = {
        --   enabled = true,
        -- },
      }

      -- Required for `opts.events.reload`.
      vim.o.autoread = true
    end,
  },
}
