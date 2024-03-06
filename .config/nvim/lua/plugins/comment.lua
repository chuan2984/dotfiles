return {
  'numToStr/Comment.nvim',
  --event = { 'BufReadPre', 'BufNewFile' },
  event = 'VeryLazy',
  config = true, -- runs require('Comment').setup()
}
