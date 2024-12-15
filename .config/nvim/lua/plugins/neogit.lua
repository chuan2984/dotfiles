return {
  'NeogitOrg/neogit',
  keys = {
    {
      '<leader>gs',
      mode = 'n',
      ':Neogit kind=auto<CR>',
      desc = 'Git status',
    },
    {
      '<leader>gp',
      mode = 'n',
      ':Neogit pull<CR>',
      desc = 'Git pull',
    },
    {
      '<leader>gP',
      mode = 'n',
      ':Neogit push<CR>',
      desc = 'Git push',
    },
    {
      '<leader>gcc',
      mode = 'n',
      ':Neogit commit<CR>',
      desc = 'Git commit',
    },
    {
      '<leader>gd',
      mode = 'n',
      ':DiffviewOpen<CR>',
      desc = 'Diff this',
    },
    {
      '<leader>gfh',
      mode = 'n',
      ':DiffviewFileHistory<CR>',
      desc = 'Diff file history',
    },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'sindrets/diffview.nvim',
    'nvim-telescope/telescope.nvim',
  },
  cmd = { 'Neogit', 'DiffviewOpen', 'DiffviewFileHistory' },
  config = true,
}
