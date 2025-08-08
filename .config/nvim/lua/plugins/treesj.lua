return {
  'Wansmer/treesj',
  keys = {
    {
      'gS',
      function()
        require('treesj').toggle()
      end,
      desc = 'Toggle split and join',
      remap = false,
    },
  },
  dependencies = 'nvim-treesitter/nvim-treesitter',
  config = function()
    require('treesj').setup {
      use_default_keymaps = false,
      max_join_length = 500,
    }
    -- require('which-key').add {
    --   g = {
    --     S = {
    --       function()
    --         require('treesj').toggle()
    --       end,
    --       mode = 'n',
    --       'Toggle split and join',
    --     },
    --   },
    -- }
    -- vim.keymap.set('n', 'gS', require('treesj').toggle, { desc = 'Toggle expand' })
  end,
}
