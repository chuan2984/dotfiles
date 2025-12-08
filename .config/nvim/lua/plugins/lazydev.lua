return {
  'folke/lazydev.nvim',
  dependencies = {
    { 'Bilal2453/luvit-meta', lazy = true },
    { 'DrKJeff16/wezterm-types', lazy = true, version = false },
  },
  ft = 'lua', -- only load on lua files
  cmd = { 'LazyDev' },
  opts = {
    library = {
      -- See the configuration section for more details
      -- Load luvit types when the `vim.uv` word is found
      'lazy.nvim',
      'snacks.nvim',
      { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      { path = '~/.hammerspoon/Spoons/EmmyLua.spoon/annotations' },
      { path = 'wezterm-types', mods = { 'wezterm' } },
    },
  },
}
