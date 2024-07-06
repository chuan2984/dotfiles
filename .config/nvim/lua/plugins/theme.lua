return {
  'catppuccin/nvim',
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    require('catppuccin').setup {
      flavour = 'auto', -- latte, frappe, macchiato, mocha
      transparent_background = true,
    }

    vim.cmd.colorscheme 'catppuccin'

    -- Used to set theme for obsidian files after file is read
    vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
      group = vim.api.nvim_create_augroup('autoset theme', { clear = true }),
      pattern = '*', -- Matches all files
      callback = function()
        local is_obsidian_file = vim.fn.expand('%:p'):lower():match 'obsidian'
        if is_obsidian_file then
          vim.cmd.colorscheme 'kanagawa'
        end
      end,
    })
  end,
}
