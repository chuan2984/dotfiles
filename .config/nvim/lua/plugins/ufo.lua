return {
  'kevinhwang91/nvim-ufo',
  dependencies = 'kevinhwang91/promise-async',
  keys = {
    {
      'zR',
      function()
        require('ufo').openAllFolds()
      end,
      { desc = 'open all folds' },
    },
    {
      'zM',
      function()
        require('ufo').closeAllFolds()
      end,
      { desc = 'close all folds' },
    },
    {
      'zr',
      function()
        require('ufo').openFoldsExceptKinds()
      end,
      { desc = 'close all folds except kinds' },
    },
    {
      'zm',
      function()
        require('ufo').closeFoldsWith(vim.v.count)
      end,
      { desc = 'close folds with {v:count}' },
    },
    {
      'zK',
      function()
        local winid = require('ufo').peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end,
      { desc = 'Peek Fold' },
    },
  },
  event = 'VeryLazy',
  config = function()
    local ftMap = {
      vim = 'indent',
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
        :thenCall(function(ufo_folds)
          local ok, jupynium = pcall(require, 'jupynium')
          if ok then
            for _, fold in ipairs(jupynium.get_folds()) do
              table.insert(ufo_folds, fold)
            end
          end
          return ufo_folds
        end)
    end

    local show_folded_line_num_handler = function(virtText, lnum, endLnum, width, truncate)
      local newVirtText = {}
      local suffix = (' 󰁂 %d '):format(endLnum - lnum)
      local sufWidth = vim.fn.strdisplaywidth(suffix)
      local targetWidth = width - sufWidth
      local curWidth = 0
      for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
          table.insert(newVirtText, chunk)
        else
          chunkText = truncate(chunkText, targetWidth - curWidth)
          local hlGroup = chunk[2]
          table.insert(newVirtText, { chunkText, hlGroup })
          chunkWidth = vim.fn.strdisplaywidth(chunkText)
          -- str width returned from truncate() may less than 2nd argument, need padding
          if curWidth + chunkWidth < targetWidth then
            suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
          end
          break
        end
        curWidth = curWidth + chunkWidth
      end
      table.insert(newVirtText, { suffix, 'MoreMsg' })
      return newVirtText
    end

    require('ufo').setup {
      fold_virt_text_handler = show_folded_line_num_handler,
      provider_selector = function(bufnr, filetype, buftype)
        return ftMap[filetype] or customizeSelector
      end,
    }
  end,
}
