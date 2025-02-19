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

      matchup = { enable = true },

      -- TODO: need to setup treesitter textobject apporpirately
      textobjects = {
        select = {
          enable = false,
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,

          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['a_'] = '@block.outer',
            ['i_'] = '@block.inner',
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
            ['@block.outer'] = 'v', -- charwise
            ['@function.outer'] = 'V', -- linewise
            ['@class.outer'] = 'V', -- blockwise
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
    local bt = require 'mini.bracketed'

    local function repeatable_keymap_pair(key, next_func, prev_func, desc_name)
      local next_repeat, prev_repeat = ts_repeat_move.make_repeatable_move_pair(next_func, prev_func)

      local desc = '[' .. desc_name:sub(1, 1) .. ']' .. desc_name:sub(2)

      vim.keymap.set({ 'n', 'x', 'o' }, ']' .. key, next_repeat, { desc = 'Next' .. desc })
      vim.keymap.set({ 'n', 'x', 'o' }, '[' .. key, prev_repeat, { desc = 'Prev' .. desc })
    end

    -- stylua: ignore start
    repeatable_keymap_pair('h', function() gs.nav_hunk 'next' end, function() gs.nav_hunk 'prev' end, 'hunk')
    repeatable_keymap_pair('b', function() bt.buffer 'forward' end, function() bt.buffer 'backward' end, 'buffer')
    repeatable_keymap_pair('c', function() bt.comment 'forward' end, function() bt.comment 'backward' end, 'comment')
    repeatable_keymap_pair('d', function() bt.diagnostic 'forward' end, function() bt.diagnostic 'backward' end, 'diagnostic')
    repeatable_keymap_pair('i', function() bt.indent 'forward' end, function() bt.indent 'backward' end, 'indent')
    repeatable_keymap_pair('j', function() bt.jump 'forward' end, function() bt.jump 'backward' end, 'jump')
    repeatable_keymap_pair('l', function() bt.location 'forward' end, function() bt.location 'backward' end, 'location')
    repeatable_keymap_pair('o', function() bt.oldfile 'forward' end, function() bt.oldfile 'backward' end, 'oldfile')
    repeatable_keymap_pair('q', function() bt.quickfix 'forward' end, function() bt.quickfix 'backward' end, 'quickfix')
    repeatable_keymap_pair('t', function() bt.treesitter 'forward' end, function() bt.treesitter 'backward' end, 'treesitter')
    repeatable_keymap_pair('u', function() bt.undo 'forward' end, function() bt.undo 'backward' end, 'undo')
    repeatable_keymap_pair('w', function() bt.window 'forward' end, function() bt.window 'backward' end, 'window')
    repeatable_keymap_pair('y', function() bt.yank 'forward' end, function() bt.yank 'backward' end, 'yank')
    -- stylua: ignore end
  end,
}

-- vim: ts=2 sts=2 sw=2 et
