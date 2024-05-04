return {
  'm4xshen/hardtime.nvim',
  keys = { 'j', 'h', 'k', 'l' },
  dependencies = { 'MunifTanjim/nui.nvim', 'nvim-lua/plenary.nvim' },
  opts = {
    max_time = 600,
    max_count = 5,
    disable_mouse = false,
    disabled_filetypes = { 'qf', 'netrw', 'lazy', 'mason', 'oil' },
  },
}
