-- [[ Basic Keymaps ]]
--  See `:help keymap.set()`
--
local opts = { noremap = true, silent = false }
local keymap = vim.keymap.set

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
keymap('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
keymap('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' }, opts)
keymap('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' }, opts)
keymap('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' }, opts)
keymap('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' }, opts)

-- Currently handled by a plugin
-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
--keymap('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' }, opts)
--keymap('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' }, opts)
--keymap('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' }, opts)
--keymap('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' }, opts)

-- Navigate buffers
keymap('n', '<S-l>', ':bnext<CR>', opts)
keymap('n', '<S-h>', ':bprevious<CR>', opts)

-- Visual --
-- Stay in indent mode keymap("v", "<", "<gv", opts)
keymap('v', '>', '>gv', opts)
keymap('v', '<', '<gv', opts)

-- Paste without yanking the original text
-- Terminal --
keymap('v', '<Leader>p', '"_dP', opts)
-- Delete without yanking the original text
keymap('v', '<Leader>d', '"_d', opts)
keymap('n', '<Leader>d', '"_d', opts)
keymap('n', '<Leader>x', '"_x', opts)
keymap('n', '<Leader>X', '"_X', opts)

-- Terminal --
-- Better terminal navigation
-- keymap('t', '<C-h>', '<C-\\><C-N><C-w>h', term_opts)
-- keymap('t', '<C-j>', '<C-\\><C-N><C-w>j', term_opts)
-- keymap('t', '<C-k>', '<C-\\><C-N><C-w>k', term_opts)
-- keymap('t', '<C-l>', '<C-\\><C-N><C-w>l', term_opts)

-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
keymap('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- vim: ts=2 sts=2 sw=2 et
