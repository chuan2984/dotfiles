return {
  {
    'nvzone/typr',
    dependencies = 'nvzone/volt',
    opts = {},
    cmd = { 'Typr', 'TyprStats' },
  },
  {
    'Rtarun3606k/TakaTime',
    lazy = false,
    config = function()
      require('taka-time').setup {
        debug = false,
      }
    end,
  },
}
