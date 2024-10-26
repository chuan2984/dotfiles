return {
  'nvim-treesitter/nvim-treesitter',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = {
    {
      'RRethy/nvim-treesitter-endwise',
      event = 'InsertEnter',
    },
    {
      'nvim-treesitter/nvim-treesitter-context',
      config = true,
    },
    {
      'HiPhish/rainbow-delimiters.nvim',
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
          enable = true,
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,

          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            -- You can optionally set descriptions to the mappings (used in the desc parameter of
            -- nvim_buf_set_keymap) which plugins like which-key display
            ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class region' },
            -- You can also use captures from other query groups like `locals.scm`
            ['as'] = { query = '@local.scope', query_group = 'locals', desc = 'Select language scope' },
          },
          -- You can choose the select mode (default is charwise 'v')
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * method: eg 'v' or 'o'
          -- and should return the mode ('v', 'V', or '<c-v>') or a table
          -- mapping query_strings to modes.
          selection_modes = {
            ['@parameter.outer'] = 'v', -- charwise
            ['@function.outer'] = 'V', -- linewise
            ['@class.outer'] = '<c-v>', -- blockwise
          },
          -- If you set this to `true` (default is `false`) then any textobject is
          -- extended to include preceding or succeeding whitespace. Succeeding
          -- whitespace has priority in order to act similarly to eg the built-in
          -- `ap`.
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * selection_mode: eg 'v'
          -- and should return true or false
          -- include_surrounding_whitespace = true,
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            [']f'] = '@function.outer',
          },
          goto_previous_start = {
            ['[f'] = '@function.outer',
          },
        },
      },

      endwise = {
        enable = true,
      },
    }

    local ts_repeat_move = require 'nvim-treesitter.textobjects.repeatable_move'

    -- Repeat movement with ; and ,
    vim.keymap.set({ 'n', 'x', 'o' }, '<leader>;', function()
      local success = ts_repeat_move.repeat_last_move_next()
      if not success then
        vim.cmd 'normal! ;'
      end
    end, { desc = 'repeat last textobject move' })

    vim.keymap.set({ 'n', 'x', 'o' }, '<leader>,', function()
      local success = ts_repeat_move.repeat_last_move_previous()
      if not success then
        vim.cmd 'normal! ,'
      end
    end, { desc = 'repeat prev textobject move' })

    -- vim way: ; goes to the direction you were moving.
    -- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
    -- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
    local gs = require 'gitsigns'

    -- make sure forward function comes first
    local next_hunk_repeat, prev_hunk_repeat = ts_repeat_move.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)
    vim.keymap.set({ 'n', 'x', 'o' }, ']h', next_hunk_repeat)
    vim.keymap.set({ 'n', 'x', 'o' }, '[h', prev_hunk_repeat)

    local next_diag, prev_diag =
      ts_repeat_move.make_repeatable_move_pair(vim.diagnostic.goto_next, vim.diagnostic.goto_prev)
    vim.keymap.set('n', '[d', next_diag, { desc = 'Go to previous [D]iagnostic message' })
    vim.keymap.set('n', ']d', prev_diag, { desc = 'Go to next [D]iagnostic message' })
  end,
}

-- vim: ts=2 sts=2 sw=2 et
