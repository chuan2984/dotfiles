return {
  'otavioschwanck/arrow.nvim',
  keys = {
    'm',
    "'",
    {
      'H',
      function()
        require('arrow.persist').previous()
      end,
      desc = 'previous marked file',
    },
    {
      'L',
      function()
        require('arrow.persist').toggle()
      end,
      desc = 'next marked file',
    },
    {
      "<C-'>",
      function()
        require('arrow.persist').toggle()
      end,
      desc = 'bookmark buffer',
    },
    { 'mn', '<cmd>Arrow next_buffer_bookmark<CR>', desc = 'next bookmark in buffer' },
    { 'mp', '<cmd>Arrow prev_buffer_bookmark<CR>', desc = 'prev bookmark in buffer' },
    { '<C-s>', '<cmd>Arrow toggle_current_line_for_buffer<CR>', desc = 'save bookmark in buffer' },
  },
  config = function()
    require('arrow').setup {
      show_icons = true,
      leader_key = "'", -- Recommended to be a single key
      buffer_leader_key = 'm', -- Per Buffer Mappings
      separate_by_branch = true,
      index_keys = 'hjkl;gfa',
    }

  end,
}
