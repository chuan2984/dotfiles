return {
  'epwalsh/obsidian.nvim',
  version = '*', -- recommended, use latest release instead of latest commit
  event = {
    'BufReadPre ' .. vim.fn.expand '~' .. '/github/obsidian/**.md',
    'BufNewFile ' .. vim.fn.expand '~' .. '/github/obsidian/**.md',
  },
  keys = {
    {
      '<leader>so',
      function()
        local home_dir = os.getenv 'HOME'
        local find_command = { 'rg', '--files', '--glob', '!**/.git/*' }
        require('telescope.builtin').find_files {
          find_command = find_command,
          cwd = home_dir .. '/GitHub/obsidian/2ndBrain',
        }
      end,
      desc = '[S]earch [O]bsidian',
    },
    {
      '<leader>ot',
      '<CMD>ObsidianToday<CR>',
      desc = '[O]bsidian [T]oday',
    },
    {
      '<leader>ont',
      '<CMD>ObsidianNewFromTemplate<CR>',
      desc = '[O]bsidian [n]ew [t]emplate',
    },
  },
  dependencies = {
    -- Required.
    'nvim-lua/plenary.nvim',
  },
  config = function()
    vim.o.conceallevel = 2

    local opts = {
      workspaces = {
        {
          name = 'work',
          path = '~/GitHub/obsidian/2ndBrain',
        },
      },

      log_level = vim.log.levels.INFO,

      -- daily_notes = {
      --   -- Optional, if you keep daily notes in a separate directory.
      --   folder = 'Periodic Notes/Daily',
      --   -- Optional, if you want to change the date format for the ID of daily notes.
      --   date_format = '%Y-%m-%d-%A',
      --   -- Optional, if you want to change the date format of the default alias of daily notes.
      --   -- alias_format = '%B %-d, %Y',
      --   -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
      --   template = nil,
      -- },

      completion = {
        -- Set to false to disable completion.
        nvim_cmp = false,
        -- Trigger completion at 2 chars.
        min_chars = 2,
      },

      -- Optional, configure key mappings. These are the defaults. If you don't want to set any keymappings this
      -- way then set 'mappings = {}'.
      mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        ['gf'] = {
          action = function()
            if require('obsidian').util.cursor_on_markdown_link() then
              return '<cmd>ObsidianFollowLink<CR>'
            else
              return 'gf'
            end
          end,
          opts = { noremap = false, expr = true, buffer = true, desc = '[G]o to [F]ile or Link' },
        },
        -- Toggle check-boxes.
        ['<leader>oc'] = {
          action = function()
            return require('obsidian').util.toggle_checkbox()
          end,
          opts = { buffer = true, desc = '[O]bsidian Toggle [C]heckbox' },
        },
        ['<leader>oat'] = {
          action = function()
            return vim.cmd 'ObsidianTemplate'
          end,
          opts = { buffer = true, desc = '[O]bsidian [a]pply [t]emplate' },
        },
      },

      disable_frontmatter = true,
      -- This configuration for lighlight and conceal does not work, replicated at the bottom
      -- This requires you have `conceallevel` set to 1 or 2. See `:help conceallevel` for more details.
      ui = {
        enable = false, -- set to false to disable all additional syntax features
        update_debounce = 200, -- update delay after a text change (in milliseconds)
      },

      new_notes_location = 'notes_subdir',
      -- Either 'wiki' or 'markdown'.
      preferred_link_style = 'wiki',

      -- Optional, for templates (see below).
      templates = {
        subdir = 'Templates alt',
        date_format = '%Y-%m-%d',
        time_format = '%H:%M',
        -- A map for custom variables, the key should be the variable and the value a function
        substitutions = {},
      },

      -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
      -- URL it will be ignored but you can customize this behavior here.
      ---@param url string
      follow_url_func = function(url)
        -- Open the URL in the default web browser.
        vim.fn.jobstart { 'open', url } -- Mac OS
        -- vim.fn.jobstart({"xdg-open", url})  -- linux
      end,

      -- Optional, set to true if you use the Obsidian Advanced URI plugin.
      -- https://github.com/Vinzent03/obsidian-advanced-uri
      use_advanced_uri = false,

      -- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground.
      open_app_foreground = true,

      picker = {
        -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
        name = 'telescope.nvim',
        -- Optional, configure key mappings for the picker. These are the defaults.
        -- Not all pickers support all mappings.
        mappings = {
          -- Create a new note from your query.
          new = '<C-o>',
          -- Insert a link to the selected note.
          insert_link = '<C-l>',
        },
      },

      -- Optional, sort search results by "path", "modified", "accessed", or "created".
      -- The recommend value is "modified" and `true` for `sort_reversed`, which means, for example,
      -- that `:ObsidianQuickSwitch` will show the notes sorted by latest modified time
      sort_by = 'modified',
      sort_reversed = true,

      -- Optional, determines how certain commands open notes. The valid options are:
      -- 1. "current" (the default) - to always open in the current window
      -- 2. "vsplit" - to open in a vertical split if there's not already a vertical split
      -- 3. "hsplit" - to open in a horizontal split if there's not already a horizontal split
      open_notes_in = 'current',
    }

    vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile', 'TextChanged', 'TextChangedI' }, {
      pattern = '*.md',
      group = vim.api.nvim_create_augroup('MarkdownSyntaxCustomization', { clear = true }),
      callback = function()
        -- Execute Vimscript command to define the syntax region
        -- Used to hide codeblock that starts with dataview
        vim.cmd [[ syntax region DataViewBlock start=/^\(```dataview\|^```dataviewjs\)/ end=/^```/ conceal cchar=* ]]
      end,
    })

    require('obsidian').setup(opts)
  end,
}
