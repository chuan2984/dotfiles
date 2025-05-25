return {
  'kevinhwang91/nvim-bqf',
  build = function()
    vim.fn['fzf#install']()
  end,
  dependencies = {
    'junegunn/fzf',
    'nvim-treesitter/nvim-treesitter',
  },
}
