return {
  'rgroli/other.nvim',
  cmd = 'Other',
  keys = {
    {
      '<leader>al',
      mode = 'n',
      '<cmd>:Other<CR>',
      desc = 'Alternate files',
    },
    {
      '<leader>av',
      mode = 'n',
      '<cmd>:OtherVSplit<CR>',
      desc = 'Alternate(vertical) files',
    },
    {
      '<leader>as',
      mode = 'n',
      '<cmd>:OtherSplit<CR>',
      desc = 'Alternate(horizontal) files',
    },
    {
      '<leader>ac',
      mode = 'n',
      '<cmd>:OtherClear<CR>',
      desc = 'Alternate files clear',
    },
    {
      '<leader>at',
      mode = 'n',
      '<cmd>:Other test<CR>',
      desc = 'Alternate files(test)',
    },
    {
      '<leader>as',
      mode = 'n',
      '<cmd>:Other source<CR>',
      desc = 'Alternate files(source)',
    },
  },
  config = function()
    require('other-nvim').setup {
      mappings = {
        'rails',
        {
          pattern = '(.*)/src/main/kotlin/(.*)/(.*).kt$',
          target = {
            { target = '%1/src/test/kotlin/**/%3Test.kt' },
            { target = '%1/src/test/kotlin/%2/%3Test.kt' },
          },
          context = 'test',
        },
        {
          pattern = '(.*)/src/test/kotlin/(.*)/(.*)Test%.kt$',
          target = {
            { target = '%1/src/main/kotlin/%2/%3.kt' },
            { target = '%1/src/main/kotlin/**/%3.kt' },
          },
          context = 'source',
        },
      },
      style = {
        border = 'rounded',
        minHeight = 3,
      },
    }
  end,
}
