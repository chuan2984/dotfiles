return {
  -- {
  --   'folke/tokyonight.nvim',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require('tokyonight').setup {
  --       style = 'night',
  --
  --       styles = {
  --         floats = 'transparent',
  --         sidebars = 'transparent',
  --       },
  --       transparent = true,
  --       on_colors = function(colors)
  --         colors.error = '#b52d2d' -- a lighter red
  --       end,
  --       on_highlights = function(hl, c)
  --         hl.RenderMarkdownCode = {
  --           bg = c.none,
  --         }
  --         hl.Pmenu = {
  --           bg = c.none,
  --         }
  --         hl.Float = {
  --           bg = c.none,
  --         }
  --         hl.NormalFloat = {
  --           bg = c.none,
  --         }
  --       end,
  --     }
  --     local default_theme = 'tokyonight-night'
  --     vim.cmd.colorscheme(default_theme)
  --   end,
  -- },
  {
    'catppuccin/nvim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require('catppuccin').setup {
        flavour = 'mocha', -- latte, frappe, macchiato, mocha
        transparent_background = true,
        custom_highlights = function(colors)
          return {
            Pmenu = { bg = colors.none },
            RenderMarkdownCode = { bg = colors.none },
            RenderMarkdownCodeInline = { bg = colors.none },
            Float = { bg = colors.none },
            NormalFloat = { bg = colors.none },
          }
        end,
      }
      local default_theme = 'catppuccin-mocha'
      vim.cmd.colorscheme(default_theme)

      -- vim.api.nvim_create_autocmd({ 'BufEnter' }, {
      --   group = vim.api.nvim_create_augroup('autoset theme', { clear = true }),
      --   pattern = '*',
      --   callback = function()
      --     local is_markdown = vim.bo.filetype == 'markdown'
      --     local curr_theme = vim.g.colors_name
      --     local buftype = vim.bo.buftype
      --     local filetype = vim.bo.filetype
      --     local bufname = vim.api.nvim_buf_get_name(0) -- 0 refers to the current buffer
      --
      --     local is_a_file_buffer = buftype == '' and filetype ~= '' and vim.fn.filereadable(bufname) == 1
      --
      --     local theme = default_theme
      --     if is_markdown then
      --       theme = markdown_theme
      --     end
      --
      --     if is_a_file_buffer and curr_theme ~= theme then
      --       vim.cmd.colorscheme(theme)
      --       -- HACK: Without this, highlight would not showup
      --       -- using BufReadPost would avoid this problem, but theme switching would then be buggy
      --       vim.schedule(function()
      --         vim.cmd 'Lazy reload todo-comments.nvim'
      --       end)
      --     end
      --   end,
      -- })
    end,
  },
}
