-- [[ Basic Keymaps ]]
--  See `:help keymap.set()`
--
local opts = { noremap = true, silent = false }
local keymap = vim.keymap.set

vim.keymap.set('i', 'jk', '<Esc>', opts)
-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- config lua helper
keymap('v', '<leader>xl', "<cmd>:'<,'>lua<CR>", { desc = 'Execute visually selected lines' })
keymap('n', '<leader>xf', '<cmd>source %<CR>', { desc = 'Execute the current file' })

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
keymap('n', '<Esc>', '<cmd>nohlsearch<CR>')
keymap({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Diagnostic keymaps
keymap('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' }, opts)
keymap('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' }, opts)
keymap('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' }, opts)

-- Currently handled by a plugin
-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
--keymap('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' }, opts)
--keymap('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' }, opts)
--keymap('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' }, opts)
--keymap('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' }, opts)

-- Navigate quickfix list
keymap('n', ']q', ':cnext<CR>', { desc = 'Go to previous item in quickfix list' }, opts)
keymap('n', '[q', ':cprevious<CR>', { desc = 'Go to next item in quickfix list' }, opts)

-- Navigate buffers
keymap('n', ']b', ':bnext<CR>', opts)
keymap('n', '[b', ':bprevious<CR>', opts)
keymap('n', '<leader>bb', '<C-^>', { desc = 'alternate file' }, opts)

-- Visual --
keymap('v', '>', '>gv', opts)
keymap('v', '<', '<gv', opts)

-- Vertical movement
keymap('n', '<C-d>', '<C-d>', opts)
keymap('n', '<C-u>', '<C-u>', opts)

-- Recenter search
keymap('n', 'n', 'nzv', opts)
keymap('n', 'N', 'Nzv', opts)

-- Paste without yanking the original text
-- Terminal --
keymap('v', '<Leader>p', '"_dP', opts)
-- Delete without yanking the original text
keymap('v', '<Leader>d', '"_d', opts)
keymap('n', '<Leader>d', '"_d', opts)
keymap('n', '<Leader>x', '"_x', opts)
keymap('n', '<Leader>X', '"_X', opts)

keymap('n', '<leader>cpr', function()
  local abs_file_path = vim.fn.expand '%:p'
  local git_root = Snacks.git.get_root()
  local rel_file_path = abs_file_path:sub(#git_root + 2)
  vim.fn.setreg('+', rel_file_path)
  vim.notify('Copied relative_path to system clipboard: ' .. rel_file_path)
end, { desc = '[copy] [p]ath [r]elative' })

keymap('n', '<leader>cpa', '<cmd>let @+ = expand("%:p")<CR>', { desc = '[C]opy [p]ath [a]bsolute' }, opts)

-- Terminal --
-- Better terminal navigation
-- keymap('t', '<C-h>', '<C-\\><C-N><C-w>h', term_opts)
-- keymap('t', '<C-j>', '<C-\\><C-N><C-w>j', term_opts)
-- keymap('t', '<C-k>', '<C-\\><C-N><C-w>k', term_opts)
-- keymap('t', '<C-l>', '<C-\\><C-N><C-w>l', term_opts)

-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
keymap('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Custom Neovim Tips
require('neovim_tips').setup {
  daily_tip = true,
}
keymap('n', '<leader>vt', '<cmd>NeovimTips<cr>', { desc = 'Neovim Tips' })
keymap('n', '<leader>vT', '<cmd>NeovimTipsRandom<cr>', { desc = 'Random Neovim Tip' })

-- vim: ts=2 sts=2 sw=2 et
