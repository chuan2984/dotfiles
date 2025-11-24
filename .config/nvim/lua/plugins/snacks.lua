return {
  ---@module 'snacks'
  'folke/snacks.nvim',
  priority = 1000,
  build = function()
    local imagemagick_installed = vim.fn.system 'command -v convert' ~= ''
    if not imagemagick_installed then
      print 'ImageMagick not found. Installing via brew...'
      vim.schedule(function()
        os.execute 'brew install imagemagick'
      end)
    else
      print 'ImageMagick already installed, examining path...'
    end
  end,
  dependencies = {
    {
      'praczet/little-taskwarrior.nvim',
      opts = {
        urgency_threshold = 10,
        dashboard = {
          limit = 6,
          debug = false,
          max_width = 56,
        },
      },
      config = true,
    },
  },
  lazy = false,
  ---@type snacks.Config
  opts = {
    gh = {},
    bigfile = { enabled = true },
    animate = { enabled = true, fps = 240, duration = 10 },
    explorer = { enabled = false },
    indent = {
      enabled = true,
      indent = {
        char = '',
        only_scope = true,
        only_current = true,
      },
      animate = {
        duration = { step = 10, total = 350 },
      },
      chunk = {
        enabled = true,
      },
    },
    image = { enabled = true },
    lazygit = { enabled = true },
    scroll = {
      enabled = true,
      animate = {
        easing = 'inQuad',
        duration = { step = 10, total = 150 },
      },
    },
    ---@type snacks.dim.Config
    dim = {
      animate = {
        duration = {
          step = 10,
          total = 50,
        },
      },
    },
    input = { enabled = true },
    dashboard = {
      enabled = true,
      sections = {
        { section = 'header' },
        {
          pane = 1,
          gap = 1,
          padding = 1,
          {
            { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
            { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
            {
              icon = ' ',
              key = 'g',
              desc = 'Git Status',
              action = ':Neogit',
              enabled = function()
                return Snacks.git.get_root() ~= nil
              end,
            },
            {
              icon = ' ',
              key = 'rc',
              desc = 'List Conflicts',
              action = ':Easypick conflicts',
              enabled = function()
                local is_git_repo = Snacks.git.get_root() ~= nil
                if not is_git_repo then
                  return false
                end

                local has_conflicts = vim.fn.system('git diff --check'):match 'conflict' ~= nil
                return has_conflicts
              end,
            },
            {
              icon = ' ',
              key = 'r',
              desc = 'Recent Files',
              action = ":lua Snacks.dashboard.pick('oldfiles')",
            },
            {
              icon = ' ',
              key = 'c',
              desc = 'Config',
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            { icon = '󰒲 ', key = 'L', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
          },
        },
        {
          pane = 1,
          icon = ' ',
          title = 'Recent Files',
          section = 'recent_files',
          cwd = true,
          indent = 2,
          padding = 1,
        },
        {
          pane = 2,
          icon = ' ',
          title = 'Git Status',
          section = 'terminal',
          enabled = function()
            return Snacks.git.get_root() ~= nil
          end,
          cmd = 'git status --short --branch --renames',
          height = 6,
          padding = 1,
          ttl = 60,
          indent = 2,
        },
        {
          pane = 2,
          icon = ' ',
          title = 'Task Status',
        },
        {
          pane = 2,
          function()
            return {
              text = require('little-taskwarrior').get_snacks_dashboard_tasks(56, 'dir', 'special'),
            }
          end,
          indent = 2,
          height = 16,
        },
        { pane = 1, section = 'startup' },
      },
    },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    gitbrowse = {
      enabled = true,
      -- WARN: no way to get default opts, can be out of sync
      -- stylua: ignore
        remote_patterns = {
          { "^(https?://.*)%.git$"              , "%1" },
          -- my own, since i have 2 different ssh account setup at a time
          { "^git@personal(.+):(.+)%.git$"      , "https://www%1/%2" },
          { "^git@work(.+):(.+)%.git$"          , "https://www%1/%2" },
          { "^git@(.+):(.+)%.git$"              , "https://%1/%2" },
          { "^git@(.+):(.+)$"                   , "https://%1/%2" },
          { "^git@(.+)/(.+)$"                   , "https://%1/%2" },
          { "^ssh://git@(.*)$"                  , "https://%1" },
          { "^ssh://([^:/]+)(:%d+)/(.*)$"       , "https://%1/%3" },
          { "^ssh://([^/]+)/(.*)$"              , "https://%1/%2" },
          { "ssh%.dev%.azure%.com/v3/(.*)/(.*)$", "dev.azure.com/%1/_git/%2" },
          { "^https://%w*@(.*)"                 , "https://%1" },
          { "^git@(.*)"                         , "https://%1" },
          { ":%d+"                              , "" },
          { "%.git$"                            , "" },
        },
    },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    picker = {
      enabled = true,
      actions = {
        cycle_preview = function(picker)
          require('plugins.snacks.custom_layout').actions.cycle_preview(picker)
        end,
        cycle_layouts = function(picker)
          require('plugins.snacks.custom_layout').actions.cycle_layouts(picker)
        end,
      },
      sources = {
        git_grep_hunks = require('plugins.snacks.custom_picker').git_grep_hunks,
        ast_grep = require('plugins.snacks.custom_picker').ast_grep,
        gh_issue = {},
        gh_pr = {},
      },
      layout = {
        preset = function()
          return require('plugins.snacks.custom_layout').layout.perferred_layout()
        end,
      },
      win = {
        input = {
          keys = {
            ['<a-c>'] = { 'cycle_preview', mode = { 'i', 'n' } },
            ['<a-v>'] = { 'cycle_layouts', mode = { 'i', 'n' } },
          },
        },
      },
    },
  },
  keys = {
    -- GH
    {
      '<leader>ghi',
      function()
        Snacks.picker.gh_issue()
      end,
      desc = 'GitHub Issues (open)',
    },
    {
      '<leader>ghI',
      function()
        Snacks.picker.gh_issue { state = 'all' }
      end,
      desc = 'GitHub Issues (all)',
    },
    {
      '<leader>ghp',
      function()
        Snacks.picker.gh_pr {
          state = 'open',
          author = 'chuan29812',
        }
      end,
      desc = 'GitHub Pull Requests (Mine open)',
    },
    {
      '<leader>ghP',
      function()
        Snacks.picker.gh_pr {
          state = 'all',
        }
      end,
      desc = 'GitHub Pull Requests (ALL)',
    },
    -- Top Pickers & Explorer
    {
      '<leader><space>',
      function()
        Snacks.picker.smart { filter = { cwd = true } }
      end,
      desc = 'Smart Find Files',
    },
    {
      '<leader>:',
      function()
        Snacks.picker.command_history()
      end,
      desc = 'Command History',
    },
    {
      '<leader>n',
      function()
        Snacks.picker.notifications()
      end,
      desc = 'Notification History',
    },
    -- find
    {
      '<leader>fb',
      function()
        Snacks.picker.buffers()
      end,
      desc = 'Buffers',
    },
    {
      '<leader>f,',
      function()
        Snacks.picker.files { cwd = vim.fn.expand '%:h' }
      end,
      desc = 'Find sibling files',
    },
    {
      '<leader>ff',
      function()
        Snacks.picker.files()
      end,
      desc = 'Find Files',
    },
    {
      '<leader>fg',
      function()
        Snacks.picker.git_files()
      end,
      desc = 'Find Git Files',
    },
    {
      '<leader>fp',
      function()
        Snacks.picker.projects()
      end,
      desc = 'Projects',
    },
    {
      '<leader>fr',
      function()
        Snacks.picker.recent { filter = { cwd = true } }
      end,
      desc = 'Recent',
    },
    -- git
    {
      '<leader>gb',
      function()
        Snacks.picker.git_branches()
      end,
      desc = 'Git Branches',
    },
    {
      '<leader>gH',
      function()
        Snacks.picker.git_grep_hunks()
        -- require('snacks').picker.pick 'git_grep_hunks'
      end,
      desc = 'Git grep [H]unks',
    },
    {
      '<leader>sast',
      function()
        Snacks.picker.ast_grep()
      end,
      desc = 'AST Grep',
    },
    {
      '<leader>gl',
      function()
        Snacks.picker.git_log()
      end,
      desc = 'Git Log',
    },
    {
      '<leader>gll',
      function()
        Snacks.picker.git_log_line()
      end,
      desc = 'Git Log Line',
    },
    {
      '<leader>gs',
      function()
        Snacks.picker.git_status()
      end,
      desc = 'Git Status',
    },
    {
      '<leader>gS',
      function()
        Snacks.picker.git_stash()
      end,
      desc = 'Git Stash',
    },
    {
      '<leader>gdh',
      function()
        Snacks.picker.git_diff()
      end,
      desc = 'Git Diff (Hunks)',
    },
    {
      '<leader>glf',
      function()
        Snacks.picker.git_log_file()
      end,
      desc = 'Git Log File',
    },
    -- Grep
    {
      '<leader>sb',
      function()
        Snacks.picker.lines()
      end,
      desc = 'Buffer Lines',
    },
    {
      '<leader>sB',
      function()
        Snacks.picker.grep_buffers()
      end,
      desc = 'Grep Open Buffers',
    },
    {
      '<leader>sg',
      function()
        Snacks.picker.grep()
      end,
      desc = 'Grep',
    },
    {
      '<leader>sw',
      function()
        Snacks.picker.grep_word()
      end,
      desc = 'Visual selection or word',
      mode = { 'n', 'x' },
    },
    -- search
    {
      '<leader>sn',
      function()
        Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
      end,
      desc = 'Search Neovim Config File',
    },
    {
      '<leader>s"',
      function()
        Snacks.picker.registers()
      end,
      desc = 'Registers',
    },
    {
      '<leader>s/',
      function()
        Snacks.picker.search_history()
      end,
      desc = 'Search History',
    },
    {
      '<leader>sa',
      function()
        Snacks.picker.autocmds()
      end,
      desc = 'Autocmds',
    },
    {
      '<leader>sb',
      function()
        Snacks.picker.lines()
      end,
      desc = 'Buffer Lines',
    },
    {
      '<leader>sc',
      function()
        Snacks.picker.command_history()
      end,
      desc = 'Command History',
    },
    {
      '<leader>sC',
      function()
        Snacks.picker.commands()
      end,
      desc = 'Commands',
    },
    {
      '<leader>sd',
      function()
        Snacks.picker.diagnostics()
      end,
      desc = 'Diagnostics',
    },
    {
      '<leader>sD',
      function()
        Snacks.picker.diagnostics_buffer()
      end,
      desc = 'Buffer Diagnostics',
    },
    {
      '<leader>sh',
      function()
        Snacks.picker.help()
      end,
      desc = 'Help Pages',
    },
    {
      '<leader>sH',
      function()
        Snacks.picker.highlights()
      end,
      desc = 'Highlights',
    },
    {
      '<leader>si',
      function()
        Snacks.picker.icons()
      end,
      desc = 'Icons',
    },
    {
      '<leader>sj',
      function()
        Snacks.picker.jumps()
      end,
      desc = 'Jumps',
    },
    {
      '<leader>sk',
      function()
        Snacks.picker.keymaps()
      end,
      desc = 'Keymaps',
    },
    {
      '<leader>sl',
      function()
        Snacks.picker.loclist()
      end,
      desc = 'Location List',
    },
    {
      '<leader>sm',
      function()
        Snacks.picker.marks()
      end,
      desc = 'Marks',
    },
    {
      '<leader>sM',
      function()
        Snacks.picker.man()
      end,
      desc = 'Man Pages',
    },
    {
      '<leader>sps',
      function()
        Snacks.picker.files { cwd = vim.fs.joinpath(vim.fn.stdpath 'data', 'lazy') }
      end,
      desc = 'Search for Plugin Spec',
    },
    {
      '<leader>sq',
      function()
        Snacks.picker.qflist()
      end,
      desc = 'Quickfix List',
    },
    {
      '<leader>sR',
      function()
        Snacks.picker.resume()
      end,
      desc = 'Resume',
    },
    {
      '<leader>su',
      function()
        Snacks.picker.undo()
      end,
      desc = 'Undo History',
    },
    {
      '<leader>uC',
      function()
        Snacks.picker.colorschemes()
      end,
      desc = 'Colorschemes',
    },
    {
      '<leader>z',
      function()
        Snacks.zen()
      end,
      desc = 'Toggle Zen Mode',
    },
    {
      '<leader>Z',
      function()
        Snacks.zen.zoom()
      end,
      desc = 'Toggle Zoom',
    },
    {
      '<leader>.',
      function()
        Snacks.scratch()
      end,
      desc = 'Toggle Scratch Buffer',
    },
    {
      '<leader>S',
      function()
        Snacks.scratch.select()
      end,
      desc = 'Select Scratch Buffer',
    },
    {
      '<leader>n',
      function()
        Snacks.notifier.show_history()
      end,
      desc = 'Notification History',
    },
    {
      '<leader>bd',
      function()
        Snacks.bufdelete()
      end,
      desc = 'Delete Buffer',
    },
    {
      '<leader>cR',
      function()
        Snacks.rename.rename_file()
      end,
      desc = 'Rename File',
    },
    {
      '<leader>gB',
      function()
        Snacks.gitbrowse()
      end,
      desc = 'Git Browse',
    },
    {
      '<leader>gbl',
      function()
        Snacks.git.blame_line()
      end,
      desc = 'Git Blame Line',
    },
    {
      '<leader>gf',
      function()
        Snacks.lazygit.log_file()
      end,
      desc = 'Lazygit Current File History',
    },
    {
      '<leader>ld',
      function()
        -- theres an option to pass in opts here to terminal
        Snacks.terminal 'lazydocker'
      end,
      desc = 'Lazydocker',
    },
    {
      '<leader>lg',
      function()
        Snacks.lazygit()
      end,
      desc = 'Lazygit',
    },
    {
      '<leader>gl',
      function()
        Snacks.lazygit.log()
      end,
      desc = 'Lazygit Log (cwd)',
    },
    {
      '<leader>un',
      function()
        Snacks.notifier.hide()
      end,
      desc = 'Dismiss All Notifications',
    },
    {
      '<c-/>',
      function()
        Snacks.terminal()
      end,
      desc = 'Toggle Terminal',
    },
    {
      '<c-_>',
      function()
        Snacks.terminal()
      end,
      desc = 'which_key_ignore',
    },
    {
      ']]',
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = 'Next Reference',
      mode = { 'n', 't' },
    },
    {
      '[[',
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = 'Prev Reference',
      mode = { 'n', 't' },
    },
    {
      '<leader>N',
      desc = 'Neovim News',
      function()
        Snacks.win {
          file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = 'yes',
            statuscolumn = ' ',
            conceallevel = 3,
          },
        }
      end,
    },
  },
  init = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Create some toggle mappings
        Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>us'
        Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>uw'
        Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>uL'
        Snacks.toggle.diagnostics():map '<leader>ud'
        Snacks.toggle.line_number():map '<leader>ul'
        Snacks.toggle
          .option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
          :map '<leader>uc'
        Snacks.toggle.treesitter():map '<leader>uT'
        Snacks.toggle.indent():map '<leader>ui'
        Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map '<leader>ub'
        Snacks.toggle.inlay_hints():map '<leader>uh'
      end,
    })
    vim.api.nvim_create_autocmd('User', {
      pattern = 'SnacksDashboardOpened',
      callback = function(data)
        vim.b[data.buf].miniindentscope_disable = true
      end,
    })
    vim.api.nvim_create_autocmd('User', {
      pattern = 'MiniFilesActionRename',
      callback = function(event)
        dd 'Calling LSP rename, may or may not work'
        Snacks.rename.on_rename_file(event.data.from, event.data.to)
      end,
    })
  end,
}
