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
    {
      'nvim-treesitter/nvim-treesitter-textobjects',
      event = 'BufRead',
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
      textobjects = {
        select = {
          enable = false,
        },
        move = {
          enable = true,
          set_jumps = true,
        },
      },

      endwise = {
        enable = true,
      },
    }

    local ts_repeat_move = require 'nvim-treesitter.textobjects.repeatable_move'

    -- Repeat movement with ; and ,
    vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move_next)
    vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_previous)

    -- vim way: ; goes to the direction you were moving.
    -- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
    -- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
    local gs = require 'gitsigns'

    -- make sure forward function comes first
    local next_hunk_repeat, prev_hunk_repeat = ts_repeat_move.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)
    vim.keymap.set({ 'n', 'x', 'o' }, ']h', next_hunk_repeat)
    vim.keymap.set({ 'n', 'x', 'o' }, '[h', prev_hunk_repeat)

    local next_diag, prev_diag = ts_repeat_move.make_repeatable_move_pair(vim.diagnostic.goto_next, vim.diagnostic.goto_prev)
    vim.keymap.set('n', '[d', next_diag, { desc = 'Go to previous [D]iagnostic message' })
    vim.keymap.set('n', ']d', prev_diag, { desc = 'Go to next [D]iagnostic message' })
  end,
}

-- vim: ts=2 sts=2 sw=2 et
