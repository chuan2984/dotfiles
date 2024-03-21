return {
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`
    'folke/tokyonight.nvim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- Used to set filetype for untraditonally named files
      vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
        group = vim.api.nvim_create_augroup('autoset theme tokyo', { clear = true }),
        pattern = '*', -- Matches all files
        callback = function()
          local theme_name = 'tokyonight'
          local is_not_obsidian_file = not vim.fn.expand('%:p'):lower():match 'obsidian'
          if vim.g.colors_name ~= theme_name and is_not_obsidian_file then
            vim.cmd.colorscheme 'tokyonight-night'
          end
        end,
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
