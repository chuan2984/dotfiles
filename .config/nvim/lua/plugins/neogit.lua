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
      '<leader>gfh',
      mode = 'n',
      ':DiffviewFileHistory<CR>',
      desc = 'Diff file history',
    },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'sindrets/diffview.nvim',
  },
  cmd = { 'Neogit', 'DiffviewOpen', 'DiffviewFileHistory' },
  config = function()
    require('neogit').setup {
      filewatcher = {
        interval = 300,
        enabled = true,
      },
      process_spinner = true,
      console_timeout = 600,
      integrations = {
        snacks = true,
        diffview = true,
      },
      -- mappings = {
      --   status = {
      --     ['<cr>'] = 'TabOpen',
      --   },
      -- },
    }
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'NeogitStatus', 'NeogitCommitView', 'NeogitPopup' },
      callback = function()
        vim.api.nvim_win_set_option(0, 'winfixbuf', true)
      end,
    })
  end,
}
