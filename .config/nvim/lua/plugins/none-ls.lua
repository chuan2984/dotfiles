return {
  'nvimtools/none-ls.nvim',
  event = 'VeryLazy',
  config = function()
    local null_ls = require 'null-ls'
    local helpers = require 'null-ls.helpers'

    local excluded_gp_path = os.getenv 'HOME' .. '/.local/share/nvim/gp/chats'

    null_ls.setup {
      -- NOTE: only using none-ls for parsing otherwise non-compatible diagnostics
      -- which usually comes from a cli or has no existing LSP
      -- formatting is done through conform, which saves me the trouble of having to
      -- write a sophicated AutoCmd for using which formatter on save
      sources = {
        null_ls.builtins.diagnostics.vale.with {
          runtime_condition = helpers.cache.by_bufnr(function(params)
            return params.bufname:find(excluded_gp_path, 1, true) == nil
          end),
        },
        null_ls.builtins.diagnostics.markdownlint.with {
          runtime_condition = helpers.cache.by_bufnr(function(params)
            return params.bufname:find(excluded_gp_path, 1, true) == nil
          end),
        },
      },
    }
  end,
}
