return {
  'folke/flash.nvim',
  opts = {
    modes = {
      char = {
        char_actions = function()
          return { [';'] = 'next', [','] = 'prev' }
        end,
        multi_line = false,
      },
    },
  },
  keys = {
    'f',
    'F',
    't',
    'T',
    {
      's',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').jump()
      end,
      desc = 'Flash',
    },
    {
      'S',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').treesitter()
      end,
      desc = 'Flash Treesitter',
    },
    {
      'r',
      mode = 'o',
      function()
        require('flash').remote()
      end,
      desc = 'Remote Flash',
    },
    {
      'R',
      mode = { 'o', 'x' },
      function()
        require('flash').treesitter_search()
      end,
      desc = 'Treesitter Search',
    },
  },
}
