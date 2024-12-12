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
      '<C-w>r',
      mode = 'n',
      function()
        require('smart-splits').start_resize_mode()
      end,
      desc = 'Resize mode',
    },
  },
  config = function()
    local smartsplits = require 'smart-splits'
    smartsplits.setup {
      default_amount = 10,
      resize_mode = {
        hooks = {
          on_enter = function()
            vim.notify 'Entering resize mode'
          end,
          on_leave = function()
            vim.notify 'Exiting resize mode, bye'
          end,
        },
      },
    }
  end,
}
