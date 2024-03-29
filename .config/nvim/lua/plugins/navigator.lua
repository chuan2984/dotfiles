return {
  'numToStr/Navigator.nvim',
  config = function()
    require('Navigator').setup()
    vim.keymap.set({ 'n', 't' }, '<C-h>', '<CMD>NavigatorLeft<CR>')
    vim.keymap.set({ 'n', 't' }, '<C-l>', '<CMD>NavigatorRight<CR>')
    vim.keymap.set({ 'n', 't' }, '<C-k>', '<CMD>NavigatorUp<CR>')
    vim.keymap.set({ 'n', 't' }, '<C-j>', '<CMD>NavigatorDown<CR>')
    vim.keymap.set({ 'n', 't' }, '<C-;>', '<CMD>NavigatorPrevious<CR>')

    vim.keymap.set({ 'n', 't' }, '<A-w>', '<c-w>+')
    vim.keymap.set({ 'n', 't' }, '<A-s>', '<c-w>-')
    vim.keymap.set({ 'n', 't' }, '<A-a>', '<c-w>>')
    vim.keymap.set({ 'n', 't' }, '<A-d>', '<c-w><')
  end,
}
