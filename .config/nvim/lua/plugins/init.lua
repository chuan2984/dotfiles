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
  {
    'Bekaboo/deadcolumn.nvim',
    event = 'InsertEnter',
    opts = {
      warning = {
        alpha = 0.2,
      },
    },
  },
  { 'tpope/vim-rails', ft = 'ruby' },
  { 'tpope/vim-abolish' }, -- cannot lazy load to work with abolish.vim config file
  { 'ludovicchabant/vim-gutentags', event = 'VeryLazy' },
  {
    'norcalli/nvim-colorizer.lua',
    event = 'BufRead',
    config = function()
      require('colorizer').setup()
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
