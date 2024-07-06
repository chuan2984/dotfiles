return {
  'kevinhwang91/nvim-ufo',
  dependencies = 'kevinhwang91/promise-async',
  event = 'VeryLazy',
  config = function()
    vim.opt.foldcolumn = '0' -- '0' is not bad
    vim.opt.foldlevel = 999
    vim.opt.foldlevelstart = -1
    vim.opt.foldenable = true
    vim.keymap.set('n', 'zK', function()
      local winid = require('ufo').peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end, { desc = 'Peek Fold' })

    require('ufo').setup {
      provider_selector = function(_, _, _)
        return { 'lsp' }
      end,
    }
  end,
}
