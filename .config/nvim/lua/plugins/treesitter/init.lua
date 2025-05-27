return {
  {
    'nvim-treesitter/nvim-treesitter',
    event = { 'BufReadPost', 'BufNewFile' },
    branch = 'main',
    build = ':TSUpdate',
    config = function()
      vim.treesitter.language.register('markdown', 'octo') -- for using Octo.nvim
      -- only enable on clean install, since this is called everytime on startup
      -- require('nvim-treesitter').install {
      --   'bash',
      --   'c',
      --   'html',
      --   'lua',
      --   'markdown_inline',
      --   'markdown',
      --   'vim',
      --   'vimdoc',
      --   'ruby',
      --   'sql',
      --   'awk',
      --   'dockerfile',
      --   'elixir',
      --   'git_rebase',
      --   'gitcommit',
      --   'gitignore',
      --   'gitattributes',
      --   'git_config',
      --   'jq',
      --   'luadoc',
      --   'rbs',
      --   'yaml',
      --   'json',
      -- }
    end,
  },
  {
    -- TODO: change it back when the original supports ts main
    -- 'RRethy/nvim-treesitter-endwise'
    'brianhuster/treesitter-endwise.nvim',
    event = 'InsertEnter',
  },
  {
    'https://github.com/ravsii/tree-sitter-d2',
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {
      enable = true,
      max_lines = 6,
    },
  },
  {
    'HiPhish/rainbow-delimiters.nvim',
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    event = 'BufRead',
    config = function()
      -- require('nvim-next.integrations').treesitter_textobjects()
      require('nvim-treesitter-textobjects').setup {
        -- nvim_next = {
        --   enable = true,
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            [']m'] = '@function.outer',
          },
          goto_next_end = {
            [']M'] = '@function.outer',
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
          },
        },
        -- },
      }
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
