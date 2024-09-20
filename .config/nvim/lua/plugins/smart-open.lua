return {
  'danielfalk/smart-open.nvim',
  branch = '0.2.x',
  dependencies = {
    'kkharji/sqlite.lua',
    -- Only required if using match_algorithm fzf
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  config = function()
    require('telescope').setup {
      extensions = {
        smart_open = {
          match_algorithm = 'fzf',
          cwd_only = true,
        },
      },
    }

    vim.keymap.set('n', '<leader><leader>', '<cmd>Telescope smart_open<CR>', { noremap = true, silent = true, desc = '[] Smart find files' })

    pcall(require('telescope').load_extension, 'smart_open')
  end,
}
