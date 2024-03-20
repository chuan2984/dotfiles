return {
  'pwntester/octo.nvim',
  cmd = 'Octo',
  requires = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('octo').setup {
      default_remote = { 'origin', 'mine' },
      ssh_aliases = {
        ['personal.github.com'] = 'github.com',
        ['work.github.com'] = 'github.com',
      },
      suppress_missing_scope = {
        projects_v2 = true,
      },
    }
  end,
}
