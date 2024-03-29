-- options are dragon, wave, lotus
require('kanagawa').setup {
  theme = 'wave',
  transparent = true,
}

vim.opt.wrap = true
vim.api.nvim_win_set_option(0, 'colorcolumn', '120')
vim.cmd 'colorscheme kanagawa'
