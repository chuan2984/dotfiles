return {
  'azorng/goose.nvim',
  config = function()
    require('goose').setup {}
  end,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MeanderingProgrammer/render-markdown.nvim',
  },
  opts = {
    prefered_picker = 'snacks',
    providers = {},
  },
}
