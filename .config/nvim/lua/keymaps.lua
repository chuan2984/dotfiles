-- [[ Basic Keymaps ]]
--  See `:help keymap.set()`
--
local default_opts = { noremap = true, silent = false }

-- Helper function to merge default opts with desc and extra opts
local function map(mode, lhs, rhs, desc, extra_opts)
  local final_opts = vim.tbl_extend('force', default_opts, { desc = desc }, extra_opts or {})
  vim.keymap.set(mode, lhs, rhs, final_opts)
end

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- config lua helper
map('v', '<leader>xl', "<cmd>:'<,'>lua<CR>", 'Execute visually selected lines')
map('n', '<leader>xf', '<cmd>source %<CR>', 'Execute the current file')

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
map('n', '<Esc>', '<cmd>nohlsearch<CR>')
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", nil, { expr = true, silent = true })
map('x', 'j', "v:count == 0 ? 'gj' : 'j'", nil, { expr = true, silent = true })
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", nil, { expr = true, silent = true })
map('x', 'k', "v:count == 0 ? 'gk' : 'k'", nil, { expr = true, silent = true })

-- Diagnostic keymaps
map('n', '[d', function()
  vim.diagnostic.jump { count = -1 }
end, 'Go to previous [D]iagnostic message')
map('n', ']d', function()
  vim.diagnostic.jump { count = 1 }
end, 'Go to next [D]iagnostic message')
map('n', '<leader>e', vim.diagnostic.open_float, 'Show diagnostic [E]rror messages')

-- Currently handled by a plugin
-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
--map('n', '<C-h>', '<C-w><C-h>', 'Move focus to the left window')
--map('n', '<C-l>', '<C-w><C-l>', 'Move focus to the right window')
--map('n', '<C-j>', '<C-w><C-j>', 'Move focus to the lower window')
--map('n', '<C-k>', '<C-w><C-k>', 'Move focus to the upper window')

-- Navigate quickfix list
map('n', ']q', ':cnext<CR>', 'Go to next item in quickfix list')
map('n', '[q', ':cprevious<CR>', 'Go to previous item in quickfix list')

-- Navigate buffers
map('n', ']b', ':bnext<CR>', 'Next buffer')
map('n', '[b', ':bprevious<CR>', 'Previous buffer')
map('n', '<leader>bb', '<C-^>', 'Alternate file')

-- Visual --
map('v', '>', '>gv', 'Indent right and reselect')
map('v', '<', '<gv', 'Indent left and reselect')

-- Vertical movement
map('n', '<C-d>', '<C-d>', 'Scroll down half page')
map('n', '<C-u>', '<C-u>', 'Scroll up half page')

-- Recenter search
map('n', 'n', 'nzv', 'Next search result (centered)')
map('n', 'N', 'Nzv', 'Previous search result (centered)')

-- Paste without yanking the original text
map('v', '<Leader>p', '"_dP', 'Paste without yanking')
-- Delete without yanking the original text
map('v', '<Leader>d', '"_d', 'Delete without yanking')
map('n', '<Leader>d', '"_d', 'Delete without yanking')
map('n', '<Leader>x', '"_x', 'Delete char without yanking')
map('n', '<Leader>X', '"_X', 'Delete char backward without yanking')

map('n', '<leader>cpr', function()
  local abs_file_path = vim.fn.expand '%:p'
  local git_root = Snacks.git.get_root()
  local rel_file_path = abs_file_path:sub(#git_root + 2)
  vim.fn.setreg('+', rel_file_path)
  vim.notify('Copied relative_path to system clipboard: ' .. rel_file_path)
end, '[C]opy [p]ath [r]elative')

map('n', '<leader>cpa', '<cmd>let @+ = expand("%:p")<CR>', '[C]opy [p]ath [a]bsolute')

-- Terminal --
-- Better terminal navigation
-- map('t', '<C-h>', '<C-\\><C-N><C-w>h', 'Move focus to the left window')
-- map('t', '<C-j>', '<C-\\><C-N><C-w>j', 'Move focus to the lower window')
-- map('t', '<C-k>', '<C-\\><C-N><C-w>k', 'Move focus to the upper window')
-- map('t', '<C-l>', '<C-\\><C-N><C-w>l', 'Move focus to the right window')

-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
map('t', '<Esc><Esc>', '<C-\\><C-n>', 'Exit terminal mode')

-- Custom Neovim Tips
require('neovim_tips').setup {
  daily_tip = true,
}
map('n', '<leader>vt', '<cmd>NeovimTips<cr>', 'Neovim Tips')
map('n', '<leader>vT', '<cmd>NeovimTipsRandom<cr>', 'Random Neovim Tip')

-- vim: ts=2 sts=2 sw=2 et
