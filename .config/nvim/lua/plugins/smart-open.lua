return {
  'danielfalk/smart-open.nvim',
  branch = '0.2.x',
  dependencies = {
    'kkharji/sqlite.lua',
    -- Only required if using match_algorithm fzf
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  config = function()
    vim.keymap.set('n', '<leader><leader>', '<cmd>Telescope smart_open<CR>', { noremap = true, silent = true, desc = '[] Smart find files' })
  end,
}
