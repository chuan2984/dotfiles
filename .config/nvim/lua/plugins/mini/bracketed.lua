local M = {}

M.setup = function()
  local bracketed = require 'mini.bracketed'
  bracketed.setup {
    file = { suffix = '' },
  }
end

return M
