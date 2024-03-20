-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins, you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
return {
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  --'sindrets/diffview.nvim', -- diffview, incase i want to use it down the line, looks promising
  { 'rebelot/kanagawa.nvim', lazy = true },
  -- This one enables GBrowse, requires a github key that can be expired
  { 'tpope/vim-rhubarb', event = 'VeryLazy' },
  { 'Bekaboo/deadcolumn.nvim', event = 'InsertEnter' },
  { 'tpope/vim-fugitive', event = 'VeryLazy' },
  { 'tpope/vim-rails', event = 'VeryLazy' },
  { 'tpope/vim-abolish', event = { 'InsertEnter', 'CmdlineEnter' } },
  { 'ludovicchabant/vim-gutentags', event = 'VeryLazy' },
  -- Use `opts = {}` to force a plugin to be loaded.
  --
  --  This is equivalent to:
  --    require('Comment').setup({})
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
}

-- vim: ts=2 sts=2 sw=2 et
