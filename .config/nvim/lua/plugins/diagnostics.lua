return {
  'rachartier/tiny-inline-diagnostic.nvim',
  event = 'VeryLazy',
  priority = 1000,
  config = function()
    require('tiny-inline-diagnostic').setup {
      -- Style preset for diagnostic messages
      -- Available options:
      -- "modern", "classic", "minimal", "powerline",
      -- "ghost", "simple", "nonerdfont", "amongus"
      preset = 'powerline',

      transparent_bg = false, -- Set the background of the diagnostic to transparent
      transparent_cursorline = true,
      options = {
        show_source = {
          enabled = true,
          if_many = true,
        },
      },
    }

    vim.diagnostic.config {
      severity_sort = true,
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅚 ',
          [vim.diagnostic.severity.WARN] = '󰀪 ',
          [vim.diagnostic.severity.INFO] = '󰋽 ',
          [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
      } or {},
    }
  end,
}
