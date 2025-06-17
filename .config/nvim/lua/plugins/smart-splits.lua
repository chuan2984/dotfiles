return {
  'mrjones2014/smart-splits.nvim',
  lazy = false,
  keys = {
    -- resize
    {
      '<CA-h>',
      mode = 'n',
      function()
        require('smart-splits').resize_left()
      end,
      desc = 'Resize Left',
    },
    {
      '<CA-j>',
      mode = 'n',
      function()
        require('smart-splits').resize_down()
      end,
      desc = 'Resize Down',
    },
    {
      '<CA-k>',
      mode = 'n',
      function()
        require('smart-splits').resize_up()
      end,
      desc = 'Resize Up',
    },
    {
      '<CA-l>',
      mode = 'n',
      function()
        require('smart-splits').resize_right()
      end,
      desc = 'Resize Right',
    },
    -- move between
    {
      '<C-h>',
      mode = 'n',
      function()
        require('smart-splits').move_cursor_left()
      end,
      desc = 'Move Cursor Left',
    },
    {
      '<C-j>',
      mode = 'n',
      function()
        require('smart-splits').move_cursor_down()
      end,
      desc = 'Move Cursor Down',
    },
    {
      '<C-k>',
      mode = 'n',
      function()
        require('smart-splits').move_cursor_up()
      end,
      desc = 'MoveCursor Up',
    },
    {
      '<C-l>',
      mode = 'n',
      function()
        require('smart-splits').move_cursor_right()
      end,
      desc = 'Move Cursor Right',
    },
    {
      '<C-b>',
      mode = 'n',
      function()
        require('smart-splits').move_cursor_previous()
      end,
      desc = 'Move Cursor Previous',
    },
    {
      '<leader><C-l>',
      mode = 'n',
      function()
        require('smart-splits').swap_buf_left()
      end,
      desc = 'Swap with the left buffer',
    },
    {
      '<leader><C-h>',
      mode = 'n',
      function()
        require('smart-splits').swap_buf_right()
      end,
      desc = 'Swap with the right buffer',
    },
    {
      '<leader><C-k>',
      mode = 'n',
      function()
        require('smart-splits').swap_buf_down()
      end,
      desc = 'Swap with the buffer below',
    },
    {
      '<leader><C-j>',
      mode = 'n',
      function()
        require('smart-splits').swap_buf_up()
      end,
      desc = 'Swap with the buffer above',
    },
    {
      -- This does not work with wezterm
      '<C-b>',
      mode = 'n',
      function()
        require('smart-splits').move_cursor_previous()
      end,
      desc = 'Move Cursor Previous',
    },
  },
  config = function()
    local smartsplits = require 'smart-splits'
    smartsplits.setup {
      default_amount = 10,
      at_edge = 'split',
    }

    vim.api.nvim_create_augroup('AutoResizeSplits', { clear = true })

    vim.api.nvim_create_autocmd('WinResized', {
      group = 'AutoResizeSplits',
      callback = function()
        vim.cmd 'wincmd ='
      end,
    })
  end,
}
