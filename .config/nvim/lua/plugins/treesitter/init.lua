return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',
    config = function()
      local ts = require 'nvim-treesitter'

      vim.treesitter.language.register('markdown', 'octo') -- for using Octo.nvim
      ts.install {
        'awk',
        'bash',
        'c',
        'comment',
        'diff',
        'dockerfile',
        'elixir',
        'git_config',
        'git_rebase',
        'gitattributes',
        'gitcommit',
        'gitignore',
        'html',
        'javascript',
        'jq',
        'json',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'rbs',
        'regex',
        'ruby',
        'sql',
        'vim',
        'vimdoc',
        'yaml',
      }

      local group = vim.api.nvim_create_augroup('TreesitterSetup', { clear = true })

      local ignore_filetypes = {
        'checkhealth',
        'lazy',
        'mason',
        'snacks_dashboard',
        'snacks_notif',
        'snacks_win',
      }

      -- Auto-install parsers and enable highlighting on FileType
      vim.api.nvim_create_autocmd('FileType', {
        group = group,
        desc = 'Enable treesitter highlighting and indentation',
        callback = function(event)
          if vim.tbl_contains(ignore_filetypes, event.match) then
            return
          end

          local lang = vim.treesitter.language.get_lang(event.match) or event.match
          local buf = event.buf

          -- Start highlighting immediately (works if parser exists)
          pcall(vim.treesitter.start, buf, lang)

          -- Enable treesitter indentation
          -- vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

          -- Install missing parsers (async, no-op if already installed)
          ts.install { lang }
        end,
      })
    end,
  },
  {
    'RRethy/nvim-treesitter-endwise',
  },
  {
    'ravsii/tree-sitter-d2',
    build = 'make nvim-install',
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
      require('nvim-treesitter-textobjects').setup {
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
  },
}

-- vim: ts=2 sts=2 sw=2 et
