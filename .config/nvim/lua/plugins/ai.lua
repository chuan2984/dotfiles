return {
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
