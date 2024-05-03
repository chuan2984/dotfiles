return {
  'danielfalk/smart-open.nvim',
  branch = '0.2.x',
  dependencies = {
    'kkharji/sqlite.lua',
    -- Only required if using match_algorithm fzf
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  config = function()
    local telescope = require 'telescope'
    telescope.load_extension 'smart_open'
    vim.keymap.set('n', '<leader><leader>', function()
      require('telescope').extensions.smart_open.smart_open {
        match_algorithm = 'fzf',
        cwd_only = true,
      }
    end, { noremap = true, silent = true, desc = '[] Smart find files' })
  end,
}
