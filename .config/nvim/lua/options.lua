-- [[ Setting options ]]
-- See `:help vim.opt`

-- Logistics
vim.opt.backup = false
vim.opt.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.opt.swapfile = false -- creates a swapfile
vim.opt.undofile = true -- enable persistent undo
vim.opt.conceallevel = 0 -- so that `` is visible in markdown files
vim.opt.fileencoding = 'utf-8' -- the encoding written to a file
vim.opt.termguicolors = true -- set term gui colors (most terminals support this)
vim.opt.showtabline = 2 -- always show tabs
vim.opt.numberwidth = 4 -- set line number column width to 2 {default 4}
vim.opt.cmdheight = 0 -- set command line height to 0 to auto hide

-- Tab spaces
vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.shiftwidth = 2 -- the number of spaces inserted for each indentation
vim.opt.tabstop = 2 -- insert 2 spaces for a tab

-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Wrapping related
vim.opt.wrap = false -- display lines as one long line
vim.opt.scrolloff = 8 -- will scroll down when there are 8 lines at the bottom of the screen
vim.opt.sidescrolloff = 8 -- same as above but for horizontal

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smartindent = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 1000 -- time to wait for a mapped sequence to complete (in milliseconds)

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- add '-' to iskeyword so that my-object is considered one word
vim.cmd [[set iskeyword+=-]]

-- vim: ts=2 sts=2 sw=2 et