return {
  'Wansmer/treesj',
  keys = 'gS',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  config = function()
    require('treesj').setup {
      use_default_keymaps = false,
      max_join_length = 240,
    }
    vim.keymap.set('n', 'gS', require('treesj').toggle)
  end,
}
