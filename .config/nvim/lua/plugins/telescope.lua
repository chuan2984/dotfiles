-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin

return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for install instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons' },
    },
    config = function()
      -- the easiest way to use telescope, is to start by doing something like:
      --  :telescope help_tags
      --
      -- two important keymaps to use while in telescope are:
      --  - insert mode: <c-/>
      --  - normal mode: ?
      --
      -- [[ configure telescope ]]
      -- see `:help telescope` and `:help telescope.setup()`
      local actions = require 'telescope.actions'
      local action_layout = require 'telescope.actions.layout'
      local config = require 'telescope.config'
      local open_with_trouble = require('trouble.sources.telescope').open

      -- Clone the default Telescope configuration
      local vimgrep_arguments = { unpack(config.values.vimgrep_arguments) }
      -- I want to search in hidden/dot files.
      table.insert(vimgrep_arguments, '--hidden')
      -- I don't want to search in the `.git` directory.
      table.insert(vimgrep_arguments, '--glob')
      table.insert(vimgrep_arguments, '!**/.git/*')

      require('telescope').setup {
        -- you can put your default mappings / updates / etc. in here
        --  all the info you're looking for is in `:help telescope.setup()`
        defaults = {
          layout_strategy = 'flex',
          vimgrep_arguments = vimgrep_arguments,
          mappings = {
            i = {
              ['<M-p>'] = action_layout.toggle_preview,
              ['<c-t>'] = open_with_trouble,
            },
            n = {
              ['<M-p>'] = action_layout.toggle_preview,
              ['<c-t>'] = open_with_trouble,
            },
          },
        },
        pickers = {
          buffers = {
            mappings = {
              n = {
                ['d'] = actions.delete_buffer,
              },
            },
          },
          find_files = {
            find_command = { 'rg', '--files', '--hidden', '--glob', '!**/.git/*' },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- enable telescope extensions, if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- see `:help telescope.builtin`
      local builtin = require 'telescope.builtin'

      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[]earch [h]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[s]earch [k]eymaps' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[s]earch [s]elect telescope' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[s]earch [d]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[s]earch [r]esume' })
      vim.keymap.set('n', '<leader>st', builtin.treesitter, { desc = '[s]earch [t]reesitter' })
      vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[ ] find existing buffers' })

      -- git
      vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = '[g]it [c]ommits' })
      vim.keymap.set('n', '<leader>gbc', builtin.git_bcommits, { desc = '[g]git [b]uffer [c]ommits' })
      vim.keymap.set('n', '<leader>gb', builtin.git_branches, { desc = '[g]git [b]branches' })
      vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = '[g]git [s]tatus' })
      vim.keymap.set('n', '<leader>gS', builtin.git_stash, { desc = '[g]git [s]tash' })

      -- slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- you can pass additional configuration to telescope to change theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] fuzzily search in current buffer' })

      -- also possible to pass additional configuration options.
      --  see `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'live grep in open files',
        }
      end, { desc = '[s]earch [/] in open files' })

      -- shortcut for searching your neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[s]earch [n]eovim files' })

      -- shortcut for searching my dotfiles
      vim.keymap.set('n', '<leader>sdot', function()
        local home_dir = os.getenv 'HOME'
        builtin.find_files { cwd = home_dir .. '/.dotfiles' }
      end, { desc = '[s]earch [DOT] files' })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
