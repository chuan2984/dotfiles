return {
  {
    'chuan2984/demicolon.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    opts = {
      keymaps = {
        horizontal_motions = true,
        -- repeat_motions = 'stateless',
        disabled_keys = { 'p', 'I', 'A' },
      },
    },
  },
  {
    'unblevable/quick-scope',
    init = function()
      -- Set globals before plugin is loaded
      vim.g.qs_buftype_blacklist = { 'terminal', 'nofile' }
    end,
  },
  {
    'folke/flash.nvim',
    opts = {
      modes = {
        char = {
          enabled = false,
        },
      },
    },
    specs = {
      {
        'folke/snacks.nvim',
        opts = {
          picker = {
            win = {
              input = {
                keys = {
                  ['<a-s>'] = { 'flash', mode = { 'n', 'i' } },
                  ['s'] = { 'flash' },
                },
              },
            },
            actions = {
              flash = function(picker)
                require('flash').jump {
                  pattern = '^',
                  label = { after = { 0, 0 } },
                  search = {
                    mode = 'search',
                    exclude = {
                      function(win)
                        return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= 'snacks_picker_list'
                      end,
                    },
                  },
                  action = function(match)
                    local idx = picker.list:row2idx(match.pos[1])
                    picker.list:_move(idx, true, true)
                  end,
                }
              end,
            },
          },
        },
      },
    },
    keys = {
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
  },
  -- {
  --   'jinh0/eyeliner.nvim',
  --   keys = { 't', 'f', 'T', 'F' },
  --   config = function()
  --     require('eyeliner').setup {
  --       highlight_on_key = true,
  --       default_keymaps = false,
  --       dim = true,
  --     }
  --     local function eyeliner_jump(key)
  --       local forward = vim.list_contains({ 't', 'f' }, key)
  --       return function()
  --         require('eyeliner').highlight { forward = forward }
  --         return require('demicolon.jump').horizontal_jump(key)()
  --       end
  --     end
  --
  --     local nxo = { 'n', 'x', 'o' }
  --     local opts = { expr = true }
  --
  --     vim.keymap.set(nxo, 'f', eyeliner_jump 'f', opts)
  --     vim.keymap.set(nxo, 'F', eyeliner_jump 'F', opts)
  --     vim.keymap.set(nxo, 't', eyeliner_jump 't', opts)
  --     vim.keymap.set(nxo, 'T', eyeliner_jump 'T', opts)
  --   end,
  -- },
}
