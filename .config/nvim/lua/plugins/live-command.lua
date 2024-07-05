return {
  'smjonas/live-command.nvim',
  event = 'BufReadPost',
  config = function()
    require('live-command').setup {
      commands = {
        Norm = { cmd = 'norm' },
      },
    }
  end,
}
