return {
  'echasnovski/mini.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('plugins.mini.ai').setup()
    require('plugins.mini.files').setup()
    require('plugins.mini.surround').setup()
    require('plugins.mini.statusline').setup()
    require('plugins.mini.bracketed').setup()
  end,
}
-- vim: ts=2 sts=2 sw=2 et
