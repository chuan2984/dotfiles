return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = 'markdown',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('render-markdown').setup {
      signs = {
        enabled = false,
      },
      heading = {
        sign = false,
        width = 'block',
        min_width = 100,
        position = 'inline',
        icons = { '󰎥', '󰎨', '󰎫', '󰎲', '󰎯', '󰎴' },
      },
      code = {
        sign = false,
        width = 'block',
        above = '',
        below = '',
        min_width = 40,
        left_pad = 2,
        right_pad = 4,
        language_pad = 0,
      },
    }
  end,
}
