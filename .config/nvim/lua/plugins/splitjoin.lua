return {
  'bennypowers/splitjoin.nvim',
  lazy = true,
  keys = {
    {
      'gj',
      function()
        require('splitjoin').join()
      end,
      desc = '[J]oin the object under cursor',
    },
    {
      'gs',
      function()
        require('splitjoin').split()
      end,
      desc = '[S]plit the object under cursor',
    },
  },
}
