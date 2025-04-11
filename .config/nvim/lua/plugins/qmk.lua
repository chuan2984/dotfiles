return {
  'codethread/qmk.nvim',
  event = 'BufReadPre *keymap.c',
  config = function()
    local group = vim.api.nvim_create_augroup('MyQMK', {})

    vim.api.nvim_create_autocmd('BufEnter', {
      desc = 'Format 5x6_5 keymap',
      group = group,
      pattern = '*5x6_5/keymaps/chuan/keymap.c',
      callback = function()
        require('qmk').setup {
          name = 'LAYOUT_5x6_5',
          auto_format_pattern = '*5x6_5/keymaps/chuan/keymap.c',
          layout = {
            'x x x x x x _ _ _ _ _ x x x x x x',
            'x x x x x x _ _ _ _ _ x x x x x x',
            'x x x x x x _ _ _ _ _ x x x x x x',
            'x x x x x x _ _ _ _ _ x x x x x x',
            '_ _ x x _ x x x _ x x x _ x x _ _',
            '_ _ _ _ _ _ x x _ x x _ _ _ _ _ _',
          },
        }
      end,
    })

    vim.api.nvim_create_autocmd('BufEnter', {
      desc = 'Format 4x6_3 keymap',
      group = group,
      pattern = '*4x6_3/keymaps/chuan/keymap.c',
      callback = function()
        require('qmk').setup {
          name = 'LAYOUT_4x6_3',
          auto_format_pattern = '*4x6_3/keymaps/chuan/keymap.c',
          layout = {
            'x x x x x x _ _ _ x x x x x x',
            'x x x x x x _ _ _ x x x x x x',
            'x x x x x x _ _ _ x x x x x x',
            '_ _ x x x x x _ x x x x x _ _',
          },
        }
      end,
    })
  end,
}
