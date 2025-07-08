return {
  'nvim-neotest/neotest',
  event = {
    -- TODO: add any test file patterns here
    'BufReadPre '
      .. vim.fn.expand '~'
      .. '/github/work/fieldwire_api/**/*_spec.rb',
  },
  enabled = true,
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'olimorris/neotest-rspec',
  },
  -- FIXME: for some reasons, when theres only one test running, the quickfix open is broken,
  -- probably due to incompatiblity issue with other qf gem im using
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
          formatter = 'json',
        },
      },
    }

    -- INFO: monkey patching to remove ansi code
    local function strip_ansi_codes(str)
      return str:gsub('\27%[[0-9;mK]*', '')
    end

    local orig_set = vim.diagnostic.set
    vim.diagnostic.set = function(ns, bufnr, diagnostics, opts)
      if ns == vim.api.nvim_create_namespace 'neotest' then
        for _, d in ipairs(diagnostics) do
          d.message = strip_ansi_codes(d.message)
        end
      end
      orig_set(ns, bufnr, diagnostics, opts)
    end

    vim.keymap.set(
      'n',
      '<leader>tr',
      ':lua require("neotest").run.run()<CR>',
      { noremap = true, silent = true, desc = '[t]est [r]un' }
    )
    vim.keymap.set(
      'n',
      '<leader>tl',
      ':lua require("neotest").run.run_last()<CR>',
      { noremap = true, silent = true, desc = '[t]est run [l]ast' }
    )
    vim.keymap.set(
      'n',
      ']n',
      ':lua require("neotest").jump.next()<CR>',
      { noremap = true, silent = true, desc = 'jump to next test' }
    )
    vim.keymap.set(
      'n',
      '[n',
      ':lua require("neotest").jump.prev()<CR>',
      { noremap = true, silent = true, desc = 'jump to previous test' }
    )
    vim.keymap.set(
      'n',
      '<leader>ta',
      ':lua require("neotest").run.attach()<CR>',
      { noremap = true, silent = true, desc = '[t]est run [a]ttach' }
    )
    vim.keymap.set(
      'n',
      '<leader>tf',
      ':lua require("neotest").run.run(vim.fn.expand("%"))<CR>',
      { noremap = true, silent = true, desc = '[t]est [f]ile run' }
    )
    vim.keymap.set(
      'n',
      '<leader>ts',
      ':lua require("neotest").run.stop()<CR>',
      { noremap = true, silent = true, desc = 'Run [t]est [s]top' }
    )
    vim.keymap.set(
      'n',
      '<leader>to',
      ':lua require("neotest").output.open()<CR>',
      { noremap = true, silent = true, desc = 'Open [t]est [o]utput' }
    )
    vim.keymap.set(
      'n',
      '<leader>tO',
      ':lua require("neotest").output_panel.toggle()<CR>',
      { noremap = true, silent = true, desc = 'open [t]est [O]utput panel' }
    )
    vim.keymap.set(
      'n',
      '<leader>tt',
      ':lua require("neotest").summary.toggle()<CR>',
      { noremap = true, silent = true, desc = '[t]est [t]oggle' }
    )
  end,
}
