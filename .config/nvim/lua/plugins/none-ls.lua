return {
  'nvimtools/none-ls.nvim',
  event = 'VeryLazy',
  config = function()
    local null_ls = require 'null-ls'

    null_ls.setup {
      -- NOTE: only using none-ls for parsing otherwise non-compatible diagnostics
      -- which usually comes from a cli or has no existing LSP
      -- formatting is done through conform, which saves me the trouble of having to
      -- write a sophicated AutoCmd for using which formatter on save
      sources = {
        null_ls.builtins.diagnostics.vale,
        null_ls.builtins.diagnostics.markdownlint,
      },
    }
  end,
}