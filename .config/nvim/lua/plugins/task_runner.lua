return {
  'chuan2984/rittli.nvim',
  keys = {
    {
      '<C-t>',
      function()
        require('rittli.conveniences.terminal_tweaks').toggle_last_openned_terminal_wezterm()
      end,
      mode = { 'n', 'i', 'x' },
    },
    { '<Esc><Esc>', '<C-\\><C-n>', mode = 't' },
    {
      '<leader>tp',
      function()
        Snacks.picker.rittli()
      end,
      desc = 'task launcher',
    },
  },
  config = function()
    require('rittli').setup {
      terminal_provider = require('rittli.core.terminal_providers.wezterm').CreateMasterLayoutProvider(),
      folder_name_with_tasks = '.rittlitasks',

      -- turn this off for non neovim terminal
      conveniences = {
        enable = false,
      },
    }
  end,
}
