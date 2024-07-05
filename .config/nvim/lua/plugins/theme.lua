return {
  'catppuccin/nvim',
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    require('catppuccin').setup {
      flavour = 'auto', -- latte, frappe, macchiato, mocha
      transparent_background = true,
    }
    -- Used to set filetype for untraditonally named files
    vim.api.nvim_create_autocmd({ 'VimEnter' }, {
      group = vim.api.nvim_create_augroup('autoset theme', { clear = true }),
      pattern = '*', -- Matches all files
      callback = function()
        local theme_name = 'catppuccin'
        local is_not_obsidian_file = not vim.fn.expand('%:p'):lower():match 'obsidian'
        if vim.g.colors_name ~= theme_name and is_not_obsidian_file then
          vim.cmd.colorscheme 'catppuccin'
        end
      end,
    })
  end,
}
