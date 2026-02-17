return {
  {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = '1.*',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = { preset = 'default' },

      appearance = {
        nerd_font_variant = 'mono',
      },

      completion = { documentation = { auto_show = true } },
      -- signature = { enabled = true },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer', 'ecolog' },
        per_filetype = {
          sql = { 'dadbod' },
          lua = { inherit_defaults = true, 'lazydev' },
        },
        providers = {
          dadbad = { module = 'vim_dadbod_completion.blink' },
          ecolog = { name = 'ecolog', module = 'ecolog.integrations.cmp.blink_cmp' },
          lazydev = { name = 'LazyDev', module = 'lazydev.integrations.blink', score_offset = 100 },
          snippets = {
            opts = {
              friendly_snippets = true,
              extended_filetyes = {
                ruby = { 'rdoc', 'rspec' },
                lua = { 'luadoc' },
              },
            },
          },
        },
      },

      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
    opts_extend = { 'sources.default' },
  },
}
-- vim: ts=2 sts=2 sw=2 et
