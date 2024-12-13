return {
  ---@module 'snacks'
  'folke/snacks.nvim',
  priority = 1000,
  dependencies = {
    {
      'praczet/little-taskwarrior.nvim',
      -- TODO: this is bugged, does not get picked up
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
    bigfile = { enabled = true },
    animate = { enabled = true, fps = 240, duration = 10 },
    indent = { enabled = false },
    ---@type snacks.scroll.Config
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
  },
  keys = {
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
      '<leader>gg',
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
  end,
}
