local M = {}

M.setup = function()
  local spec_treesitter = require('mini.ai').gen_spec.treesitter
  require('mini.ai').setup {
    custom_textobjects = {
      F = spec_treesitter { a = '@function.outer', i = '@function.inner' },
      _ = spec_treesitter { a = '@block.outer', i = '@block.inner' },
      i = function(ai_type)
        if ai_type == 'i' then
          require('mini.indentscope').textobject(false)
        else
          require('mini.indentscope').textobject(true)
        end
      end,
    },
  }
end

return M
