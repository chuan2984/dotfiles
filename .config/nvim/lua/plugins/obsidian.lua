return {
  'obsidian-nvim/obsidian.nvim',
  event = {
    'BufReadPre ' .. vim.fn.expand '~' .. '/github/obsidian/**.md',
    'BufNewFile ' .. vim.fn.expand '~' .. '/github/obsidian/**.md',
  },
  build = function()
    local pngpaste_installed = vim.fn.system 'command -v pngpaste' ~= ''
    if not pngpaste_installed then
      print 'Pngpaste not found. Installing via brew...'
      vim.schedule(function()
        os.execute 'brew install pngpaste'
      end)
    else
      print 'Pngpaste already installed, exiting...'
    end
  end,
  cmd = 'Obsidian',
  keys = {
    {
      '<leader>so',
      function()
        local home_dir = os.getenv 'HOME'
        -- local find_command = { 'rg', '--files', '--glob', '!**/.git/*' }
        Snacks.picker.files {
          cwd = home_dir .. '/GitHub/obsidian/2ndBrain',
        }
      end,
      desc = '[S]earch [O]bsidian',
    },
    {
      '<leader>ot',
      '<CMD>Obsidian today<CR>',
      desc = '[O]bsidian [T]oday',
    },
    {
      '<leader>ont',
      '<CMD>Obsidian new_from_template<CR>',
      desc = '[O]bsidian [n]ew [t]emplate',
    },
    {
      '<leader>oat',
      '<CMD>Obsidian template<CR>',
      desc = '[O]bsidian [a]pply [t]emplate',
    },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    local opts = {
      legacy_commands = false,
      workspaces = {
        {
          name = '2ndBrain',
          path = '~/GitHub/obsidian/2ndBrain',
        },
      },
      log_level = vim.log.levels.INFO,

      daily_notes = {
        -- Optional, if you keep daily notes in a separate directory.
        folder = '5. Daily',
        -- Optional, if you want to change the date format for the ID of daily notes.
        date_format = '%Y-%m-%d-%A',
        -- Optional, if you want to change the date format of the default alias of daily notes.
        -- alias_format = '%B %-d, %Y',
        -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
        template = 'Daily template.md',
      },

      completion = {
        -- Using oxide, lsp, to do this instead
        nvim_cmp = false,
        -- Trigger completion at 2 chars.
        min_chars = 2,
      },

      frontmatter = {
        enable = false,
      },
      -- This configuration for lighlight and conceal does not work, replicated at the bottom
      -- This requires you have `conceallevel` set to 1 or 2. See `:help conceallevel` for more details.
      ui = {
        enable = false, -- set to false to disable all additional syntax features
      },

      new_notes_location = 'current_dir',
      -- Either 'wiki' or 'markdown'.
      preferred_link_style = 'wiki',

      -- Optional, for templates (see below).
      templates = {
        folder = 'Templates alt',
        date_format = '%Y-%m-%d-%A',
        time_format = '%H:%M',
        -- A map for custom variables, the key should be the variable and the value a function
        substitutions = {
          yesterday = function()
            return os.date('%Y-%m-%d-%A', os.time() - 86400)
          end,
          tomorrow = function()
            return os.date('%Y-%m-%d-%A', os.time() + 86400)
          end,
        },
      },

      -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
      -- URL it will be ignored but you can customize this behavior here.
      ---@param url string
      follow_url_func = function(url)
        -- Open the URL in the default web browser.
        vim.fn.jobstart { 'open', url } -- Mac OS
        -- vim.fn.jobstart({"xdg-open", url})  -- linux
      end,

      picker = {
        -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', 'mini.pick' or 'snacks.pick'.
        name = 'snacks.pick',
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
      attachments = {
        img_folder = 'Assets/imgs',
      },
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
