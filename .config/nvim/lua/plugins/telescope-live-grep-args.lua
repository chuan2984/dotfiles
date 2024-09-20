return {
  'nvim-telescope/telescope-live-grep-args.nvim',
  version = '^1.0.0',
  event = 'VimEnter',
  dependencies = {
    {
      'nvim-telescope/telescope.nvim',
      dependencies = { 'nvim-lua/plenary.nvim' },
    },
  },
  config = function(_)
    local function live_grep_from_project_git_root()
      local function is_git_repo()
        vim.fn.system 'git rev-parse --is-inside-work-tree'

        return vim.v.shell_error == 0
      end

      local function get_git_root()
        local dot_git_path = vim.fn.finddir('.git', '.;')
        return vim.fn.fnamemodify(dot_git_path, ':h')
      end

      local options = {}

      if is_git_repo() then
        options = {
          cwd = get_git_root(),
        }
      end

      require('telescope').extensions.live_grep_args.live_grep_args(options)
    end

    require('telescope').setup {
      extensions = {
        live_grep_args = {
          auto_quoting = true, -- enable/disable auto-quoting
          -- define mappings, e.g.
          mappings = { -- extend mappings
            i = {
              ['<C-k>'] = require('telescope-live-grep-args.actions').quote_prompt(),
              ['<C-i>'] = require('telescope-live-grep-args.actions').quote_prompt { postfix = ' --iglob ' },
            },
          },
        },
      },
    }
    require('telescope').load_extension 'live_grep_args'

    local lga_shortcuts = require 'telescope-live-grep-args.shortcuts'

    vim.keymap.set('n', '<leader>sw', lga_shortcuts.grep_word_under_cursor, { desc = '[s]earch current [w]ord' })
    vim.keymap.set(
      'x',
      '<leader>sw',
      lga_shortcuts.grep_visual_selection,
      { desc = '[s]earch current [w]ord' }
      -- '"zy<Cmd>lua require("telescope.builtin").grep_string({ search = vim.fn.getreg("z"), desc = "[s]earch current [w]ord" })<CR>'
    )
    vim.keymap.set('n', '<leader>sg', live_grep_from_project_git_root, { desc = '[s]earch by [g]rep' })
  end,
}
