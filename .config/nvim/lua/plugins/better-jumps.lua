return {
  {
    'chuan2984/demicolon.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    opts = {
      keymaps = {
        horizontal_motions = false,
        -- repeat_motions = 'stateless',
        disabled_keys = { 'p', 'I', 'A' },
      },
    },
  },
  {
    'jinh0/eyeliner.nvim',
    keys = { 't', 'f', 'T', 'F' },
    config = function()
      require('eyeliner').setup {
        highlight_on_key = true,
        default_keymaps = false,
        dim = true,
      }
      local function eyeliner_jump(key)
        local forward = vim.list_contains({ 't', 'f' }, key)
        return function()
          require('eyeliner').highlight { forward = forward }
          return require('demicolon.jump').horizontal_jump(key)()
        end
      end

      local nxo = { 'n', 'x', 'o' }
      local opts = { expr = true }

      vim.keymap.set(nxo, 'f', eyeliner_jump 'f', opts)
      vim.keymap.set(nxo, 'F', eyeliner_jump 'F', opts)
      vim.keymap.set(nxo, 't', eyeliner_jump 't', opts)
      vim.keymap.set(nxo, 'T', eyeliner_jump 'T', opts)
    end,
  },
}
