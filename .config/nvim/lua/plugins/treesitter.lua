return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    {
      'RRethy/nvim-treesitter-endwise',
      event = 'InsertEnter',
    },
    {
      'nvim-treesitter/nvim-treesitter-context',
      event = 'VeryLazy',
      config = true,
    },
    {
      'HiPhish/rainbow-delimiters.nvim',
      event = 'VeryLazy',
    },
  },
  build = ':TSUpdate',
  config = function()
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    vim.treesitter.language.register('markdown', 'octo') -- for using Octo.nvim

    ---@diagnostic disable-next-line: missing-fields
    require('nvim-treesitter.configs').setup {
      ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown_inline', 'markdown', 'vim', 'vimdoc', 'ruby', 'sql' },

      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },

      -- TODO: need to setup treesitter textobject apporpirately

      endwise = {
        enable = true,
      },
    }
  end,
}

-- vim: ts=2 sts=2 sw=2 et
