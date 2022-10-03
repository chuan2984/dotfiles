-- when trying to include a directory, it automatically tries to source
-- init.lua inside that directory

-- files
require 'chuan.options'
require 'chuan.keymaps'
require 'chuan.plugins'
require 'chuan.colorscheme'
require 'chuan.cmp'
require 'chuan.telescope'
require 'chuan.treesitter'
require 'chuan.comment'
require 'chuan.gitsigns'
require 'chuan.impatient'

-- directory
require 'chuan.lsp'

-- im too basic to figure out how to do this in lua
vim.cmd('source ~/.config/nvim/vim/netrw.vim')
