return {
  'miroshQa/rittli.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  keys = {
    {
      '<C-t>',
      function()
        require('rittli.conveniences.terminal_tweaks').toggle_last_openned_terminal()
      end,
      mode = { 'n', 't' },
    },
    { '<Esc><Esc>', '<C-\\><C-n>', mode = 't' },
    {
      '<leader>tp',
      function()
        require('rittli.core.telescope').tasks_picker()
      end,
      desc = 'Pick the task',
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
