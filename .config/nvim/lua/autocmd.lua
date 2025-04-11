-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
-- INFO: replaced by yanky.nvim
-- vim.api.nvim_create_autocmd('TextYankPost', {
--   desc = 'Highlight when yanking (copying) text',
--   group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
--   callback = function()
--     vim.highlight.on_yank()
--   end,
-- })

-- always open quickfix window automatically.
-- this uses cwindows which will open it only if there are entries.
vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  group = vim.api.nvim_create_augroup('AutoOpenQuickfix', { clear = true }),
  pattern = { '[^l]*' },
  command = 'cwindow',
})

-- Triger `autoread` when files changes on disk
-- https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
-- https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  group = vim.api.nvim_create_augroup('autoread', { clear = true }),
  pattern = '*',
  command = "if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif",
})

-- Notification after file change
-- https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
vim.api.nvim_create_autocmd({ 'FileChangedShellPost' }, {
  group = vim.api.nvim_create_augroup('autoread notify', { clear = true }),
  pattern = '*',
  command = "lua vim.notify('File changed on disk. Buffer reloaded.')",
})

-- Table mapping specific file names to filetypes
local file_to_filetype = {
  gitconfig = 'gitconfig', -- Example: Map 'gitconfig' files to 'gitconfig' filetype
  ignore = 'gitignore',
}

-- Used to set filetype for untraditonally named files
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  group = vim.api.nvim_create_augroup('autoset filetype', { clear = true }),
  pattern = '*', -- Matches all files
  callback = function()
    local filename = vim.fn.expand '%:t' -- "%:t" gets the tail (name) of the current buffer's file
    for pattern, filetype in pairs(file_to_filetype) do
      if filename == pattern then
        vim.bo.filetype = filetype
        break
      end
    end
  end,
})

vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost' }, {
  group = vim.api.nvim_create_augroup('autosave on window change', { clear = true }),
  pattern = '*',
  callback = function(event)
    local writable_buffer = vim.bo[event.buf].modifiable and vim.bo[event.buf].buftype == ''
    local file_exists = vim.fn.expand '%' ~= ''
    local saved_recently = (vim.b.timestamp or 0) == vim.fn.localtime()
    local being_formatted = (vim.b.saving_format or false)

    if writable_buffer and file_exists and not saved_recently and not being_formatted then
      vim.cmd 'silent update'
    end
  end,
})
