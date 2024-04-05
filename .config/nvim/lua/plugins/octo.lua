return {
  'pwntester/octo.nvim',
  cmd = 'Octo',
  requires = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('octo').setup {
      use_local_fs = true,
      default_remote = { 'origin', 'mine' },
      enable_builtin = true,
      ssh_aliases = {
        ['personal.github.com'] = 'github.com',
        ['work.github.com'] = 'github.com',
      },
      picker = 'telescope', -- or "fzf-lua"
      picker_config = {
        use_emojis = true, -- only used by "fzf-lua" picker for now
        mappings = { -- mappings for the pickers
          open_in_browser = { lhs = '<C-o>', desc = '[o]pen issue in browser' },
          copy_url = { lhs = '<C-y>', desc = 'cop[y] url to system clipboard' },
          checkout_pr = { lhs = '<C-c>', desc = '[c]heckout pull request' },
          merge_pr = { lhs = '<C-m>', desc = '[m]erge pull request' },
        },
      },
      suppress_missing_scope = {
        projects_v2 = true,
      },
    }
  end,
}
