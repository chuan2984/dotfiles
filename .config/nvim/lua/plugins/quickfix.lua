return {
  {
    'chuan2984/nvim-bqf',
    event = 'FileType qf',
    dependencies = {
      'junegunn/fzf',
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      auto_resize_height = true,
    },
  },
  {
    'stevearc/quicker.nvim',
    event = 'FileType qf',
    -- ---@module "quicker"
    -- ---@type quicker.SetupOptions
    -- opts = {},
    config = function()
      vim.keymap.set('n', '<leader>q', function()
        require('quicker').toggle()
      end, { desc = 'Toggle quickfix' })

      vim.keymap.set('n', '<leader>l', function()
        require('quicker').toggle { loclist = true }
      end, {
        desc = 'Toggle loclist',
      })

      require('quicker').setup {
        highlight = {
          treesitter = false,
          load_buffers = false,
          lsp = true,
        },
        keys = {},
      }
    end,
  },
}
