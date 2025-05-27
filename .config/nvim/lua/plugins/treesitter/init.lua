return {
  'nvim-treesitter/nvim-treesitter',
  event = { 'BufReadPost', 'BufNewFile' },
  branch = 'main',
  dependencies = {
    {
      'https://github.com/ravsii/tree-sitter-d2',
    },
    {
      -- TODO: change it back when its supported
      -- Because it is currently not supported with the new treesitter update
      -- 'RRethy/nvim-treesitter-endwise',
      'brianhuster/nvim-treesitter-endwise',
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
      branch = 'main',
      event = 'BufRead',
    },
  },
  build = ':TSUpdate',
  config = function()
    vim.treesitter.language.register('markdown', 'octo') -- for using Octo.nvim
    -- only enable on clean install, since this is called everytime on startup
    require('nvim-treesitter').install {
      'bash',
      'c',
      'html',
      'lua',
      'markdown_inline',
      'markdown',
      'vim',
      'vimdoc',
      'ruby',
      'sql',
      'awk',
      'dockerfile',
      'elixir',
      'git_rebase',
      'gitcommit',
      'gitignore',
      'gitattributes',
      'git_config',
      'jq',
      'luadoc',
      'rbs',
      'yaml',
      'json',
    }

    require('nvim-treesitter-textobjects').setup {
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
    }
  end,
}

-- vim: ts=2 sts=2 sw=2 et
