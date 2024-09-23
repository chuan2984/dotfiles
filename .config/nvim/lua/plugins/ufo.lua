return {
  'kevinhwang91/nvim-ufo',
  dependencies = 'kevinhwang91/promise-async',
  event = 'VeryLazy',
  config = function()
    vim.keymap.set('n', 'zR', function()
      require('ufo').openAllFolds()
    end)
    vim.keymap.set('n', 'zM', function()
      require('ufo').closeAllFolds()
    end)
    vim.keymap.set('n', 'zr', function()
      require('ufo').openFoldsExceptKinds()
    end)
    vim.keymap.set('n', 'zm', function()
      require('ufo').closeFoldsWith(3)
    end)
    vim.keymap.set('n', 'zK', function()
      local winid = require('ufo').peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end, { desc = 'Peek Fold' })

    local ftMap = {
      vim = 'indent',
      python = { 'indent' },
      git = '',
    }

    ---@param bufnr number
    ---@return Promise
    local function customizeSelector(bufnr)
      local function handleFallbackException(err, providerName)
        if type(err) == 'string' and err:match 'UfoFallbackException' then
          return require('ufo').getFolds(bufnr, providerName)
        else
          return require('promise').reject(err)
        end
      end

      return require('ufo')
        .getFolds(bufnr, 'lsp')
        :catch(function(err)
          return handleFallbackException(err, 'treesitter')
        end)
        :catch(function(err)
          return handleFallbackException(err, 'indent')
        end)
    end

    require('ufo').setup {
      provider_selector = function(bufnr, filetype, buftype)
        return ftMap[filetype] or customizeSelector
      end,
    }
  end,
}
