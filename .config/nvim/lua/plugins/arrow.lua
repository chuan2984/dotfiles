return {
  'otavioschwanck/arrow.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  config = function()
    require('arrow').setup {
      show_icons = true,
      leader_key = "'", -- Recommended to be a single key
      buffer_leader_key = 'm', -- Per Buffer Mappings
      separate_by_branch = true,
      index_keys = 'hjkl;gfa',
    }

    vim.keymap.set('n', 'H', require('arrow.persist').previous)
    vim.keymap.set('n', 'L', require('arrow.persist').next)
    vim.keymap.set('n', "<C-'>", require('arrow.persist').toggle)
    vim.keymap.set('n', 'mn', '<cmd>Arrow next_buffer_bookmark<CR>')
    vim.keymap.set('n', 'mp', '<cmd>Arrow prev_buffer_bookmark<CR>')
    vim.keymap.set('n', '<C-s>', '<cmd>Arrow toggle_current_line_for_buffer<CR>')
  end,
}
