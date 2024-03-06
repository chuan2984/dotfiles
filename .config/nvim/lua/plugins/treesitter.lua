local M = {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup {
        ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc', 'ruby', 'sql' },
        -- Autoinstall languages that are not installed
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },

        incremental_selection = {
          enable = true,
        },
      }

      -- Remapping the keys again for better UX, since TS does not expose them
      local is = require 'nvim-treesitter.incremental_selection'
      vim.keymap.set('n', '<CR>', is.init_selection, { silent = true, desc = 'Init incremental selection' })
      vim.keymap.set('v', '.', is.node_incremental, { silent = true, desc = 'Node incremental selection' })
      vim.keymap.set('v', ',', is.node_decremental, { silent = true, desc = 'Node decremental selection' })
      vim.keymap.set('v', 'g.', is.scope_incremental, { silent = true, desc = 'Scope incremental selection' })
      -- Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end,
  },
}

return M
-- vim: ts=2 sts=2 sw=2 et
