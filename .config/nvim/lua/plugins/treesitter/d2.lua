local M = {}

function M.setup()
  local ok, parsers = pcall(require, 'nvim-treesitter.parsers')
  if not ok then
    vim.notify("tree-sitter-d2: can't import nvim-treesitter.parsers", vim.log.levels.WARN)
    return
  end

  parsers.d2 = {
    install_info = {
      url = 'ravsii/tree-sitter-d2',
      branch = 'main',
    },
    filetype = 'd2',
  }

  vim.filetype.add {
    extension = {
      d2 = function()
        return 'd2', function(bufnr)
          vim.bo[bufnr].commentstring = '# %s'
        end
      end,
    },
  }
end

return M
