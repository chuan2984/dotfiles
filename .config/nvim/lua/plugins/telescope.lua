return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
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
      local actions = require 'telescope.actions'
      local action_state = require 'telescope.actions.state'
      local action_layout = require 'telescope.actions.layout'
      local config = require 'telescope.config'

      local git_fixup = function(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection == nil then
          print 'No commit selected'
          return
        end

        local commit_hash = selection.value

        actions.close(prompt_bufnr)
        vim.fn.system(string.format('SKIP=lint_ci git commit --fixup=%s', commit_hash))

        if vim.v.shell_error ~= 0 then
          print 'Failed to create fixup commit'
        else
          print('Fixup commit created for ' .. commit_hash)
        end
      end

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
              ['<c-enter>'] = 'to_fuzzy_refine',
              ['<M-p>'] = action_layout.toggle_preview,
              ['<C-a>'] = 'toggle_all',
              ['<C-s>'] = actions.cycle_previewers_next,
            },
            n = {
              ['<M-p>'] = action_layout.toggle_preview,
              ['<C-a>'] = 'toggle_all',
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
          git_commits = {
            mappings = {
              n = {
                ['<C-f>'] = git_fixup,
              },
              i = {
                ['<C-f>'] = git_fixup,
              },
            },
          },
          git_bcommits = {
            mappings = {
              n = {
                ['<C-f>'] = git_fixup,
              },
              i = {
                ['<C-f>'] = git_fixup,
              },
            },
          },
          git_bcommits_range = {
            mappings = {
              n = {
                ['<C-f>'] = git_fixup,
              },
              i = {
                ['<C-f>'] = git_fixup,
              },
            },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- enable telescope extensions, if they are installed
      -- pcall(require('telescope').load_extension, 'fzf')
      -- pcall(require('telescope').load_extension, 'ui-select')
      --
      -- see `:help telescope.builtin`
      -- local builtin = require 'telescope.builtin'

      -- vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[]earch [h]elp' })
      -- vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[s]earch [k]eymaps' })
      -- vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[s]earch [s]elect telescope' })
      -- vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[s]earch [d]iagnostics' })
      -- vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[s]earch [r]esume' })
      -- vim.keymap.set('n', '<leader>st', builtin.treesitter, { desc = '[s]earch [t]reesitter' })
      -- vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[ ] find existing buffers' })

      -- git
      -- vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = '[g]it [c]ommits' })
      -- vim.keymap.set('n', '<leader>gbc', builtin.git_bcommits, { desc = '[g]git [b]uffer [c]ommits' })
      -- vim.keymap.set('n', '<leader>gb', builtin.git_branches, { desc = '[g]git [b]branches' })

      -- slightly advanced example of overriding default behavior and theme
      -- vim.keymap.set('n', '<leader>/', function()
      --   -- you can pass additional configuration to telescope to change theme, layout, etc.
      --   builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      --     winblend = 10,
      --     previewer = false,
      --   })
      -- end, { desc = '[/] fuzzily search in current buffer' })
      --
      -- also possible to pass additional configuration options.
      --  see `:help telescope.builtin.live_grep()` for information about particular keys
      -- vim.keymap.set('n', '<leader>s/', function()
      --   builtin.live_grep {
      --     grep_open_files = true,
      --     prompt_title = 'live grep in open files',
      --   }
      -- end, { desc = '[s]earch [/] in open files' })

      -- shortcut for searching your neovim configuration files
      -- vim.keymap.set('n', '<leader>sn', function()
      --   builtin.find_files { cwd = vim.fn.stdpath 'config' }
      -- end, { desc = '[s]earch [n]eovim files' })

      -- shortcut for package implementation
      -- vim.keymap.set('n', '<leader>ep', function()
      --   builtin.find_files { cwd = vim.fs.joinpath(vim.fn.stdpath 'data', 'lazy') }
      -- end, { desc = '[s]earch package files' })
      --
      -- shortcut for searching my dotfiles
      --   vim.keymap.set('n', '<leader>sdot', function()
      --     local home_dir = os.getenv 'HOME'
      --     builtin.find_files { cwd = home_dir .. '/dotfiles' }
      --   end, { desc = '[s]earch [DOT] files' })
      --
      --   vim.keymap.set('n', '<leader>s.', function()
      --     builtin.find_files { cwd = vim.fn.expand '%:p:h' }
      --   end, { desc = '[s]earch sibling files' })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
