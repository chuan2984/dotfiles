return {
  'cbochs/grapple.nvim',
  dependencies = {
    { 'nvim-tree/nvim-web-devicons', lazy = true },
  },
  event = { 'BufReadPost', 'BufNewFile' },
  cmd = 'Grapple',
  keys = {
    {
      '<C-s>',
      function()
        require('grapple').toggle()
        vim.cmd 'redrawstatus'
      end,
      desc = 'Grapple toggle tag',
    },
    { '<leader>;', '<cmd>Grapple toggle_tags<cr>', desc = 'Grapple open tags window' },
    { '<leader>n', '<cmd>Grapple cycle_tags next<cr>', desc = 'Grapple cycle next tag' },
    { '<leader>p', '<cmd>Grapple cycle_tags prev<cr>', desc = 'Grapple cycle previous tag' },
  },
  config = function()
    require('grapple').setup()
    require('telescope').load_extension 'grapple'

    MiniStatusline.section_location = function()
      return require('grapple').statusline()
    end
  end,
}
