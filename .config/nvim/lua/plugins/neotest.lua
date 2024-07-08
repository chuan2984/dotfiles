return {
  'nvim-neotest/neotest',
  keys = { '<leader>ts', '<leader>tt', '<leader>tf', '<leader>tr', '<leader>tl' },
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'olimorris/neotest-rspec',
  },
  config = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-rspec' {
          rspec_cmd = './rspec_cmd.sh',
          transform_spec_path = function(path)
            local prefix = require('neotest-rspec').root(path)
            return string.sub(path, string.len(prefix) + 2, -1)
          end,

          results_path = 'tmp/rspec.output',
        },
      },
    }

    vim.keymap.set('n', '<leader>tr', ':lua require("neotest").run.run()<CR>', { noremap = true, silent = true, desc = '[t]est [r]un' })
    vim.keymap.set('n', '<leader>tl', ':lua require("neotest").run.run_last()<CR>', { noremap = true, silent = true, desc = '[t]est run [l]ast' })
    vim.keymap.set('n', '<leader>ta', ':lua require("neotest").run.attach()<CR>', { noremap = true, silent = true, desc = '[t]est run [a]ttach' })
    vim.keymap.set('n', '<leader>tf', ':lua require("neotest").run.run(vim.fn.expand("%"))<CR>', { noremap = true, silent = true, desc = '[t]est [f]ile run' })
    vim.keymap.set('n', '<leader>ts', ':lua require("neotest").run.stop()<CR>', { noremap = true, silent = true, desc = 'Run [t]est [s]top' })
    vim.keymap.set('n', '<leader>to', ':lua require("neotest").output.open()<CR>', { noremap = true, silent = true, desc = 'Open [t]est [o]utput' })
    vim.keymap.set(
      'n',
      '<leader>tO',
      ':lua require("neotest").output_panel.toggle()<CR>',
      { noremap = true, silent = true, desc = 'open [t]est [O]utput panel' }
    )
    vim.keymap.set('n', '<leader>tt', ':lua require("neotest").summary.toggle()<CR>', { noremap = true, silent = true, desc = '[t]est [t]oggle' })
  end,
}
