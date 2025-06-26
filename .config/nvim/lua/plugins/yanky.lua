return {
  'gbprod/yanky.nvim',
  opts = {
    ring = {
      history_length = 10,
      storage = 'memory',
    },
    textobj = {
      enabled = true,
    },
  },
  keys = {
    {
      '<leader>sp',
      function()
        Snacks.picker.yanky()
      end,
      mode = { 'n', 'x' },
      desc = 'Open Yank History',
    },
    { 'y', '<Plug>(YankyYank)', mode = { 'n', 'x' }, desc = 'Yank text' },
    { 'p', '<Plug>(YankyPutAfter)', mode = { 'n', 'x' }, desc = 'Put yanked text after cursor' },
    { 'P', '<Plug>(YankyPutBefore)', mode = { 'n', 'x' }, desc = 'Put yanked text before cursor' },
    { 'gp', '<Plug>(YankyGPutAfter)', mode = { 'n', 'x' }, desc = 'Put yanked text after selection' },
    { 'gP', '<Plug>(YankyGPutBefore)', mode = { 'n', 'x' }, desc = 'Put yanked text before selection' },
    { '<c-p>', '<Plug>(YankyPreviousEntry)', desc = 'Select previous entry through yank history' },
    { '<c-n>', '<Plug>(YankyNextEntry)', desc = 'Select next entry through yank history' },
  },
  config = function(_, opts)
    require('yanky').setup(opts)

    vim.keymap.set({ 'o', 'x' }, 'iy', function()
      require('yanky.textobj').last_put()
    end, {})
  end,
}
