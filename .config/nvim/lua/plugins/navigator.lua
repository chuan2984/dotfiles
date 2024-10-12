return {
  'numToStr/Navigator.nvim',
  opts = {},
  keys = {
    { '<C-h>', '<CMD>NavigatorLeft<CR>', mode = { 'n', 't' } },
    { '<C-l>', '<CMD>NavigatorRight<CR>', mode = { 'n', 't' } },
    { '<C-k>', '<CMD>NavigatorUp<CR>', mode = { 'n', 't' } },
    { '<C-j>', '<CMD>NavigatorDown<CR>', mode = { 'n', 't' } },
    { '<C-;>', '<CMD>NavigatorPrevious<CR>', mode = { 'n', 't' } },
    { '<A-w>', '<c-w>+', mode = { 'n', 't' } },
    { '<A-s>', '<c-w>-', mode = { 'n', 't' } },
    { '<A-a>', '<c-w>>', mode = { 'n', 't' } },
    { '<A-d>', '<c-w><', mode = { 'n', 't' } },
  },
}
