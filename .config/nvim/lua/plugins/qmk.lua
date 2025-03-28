return {
  'codethread/qmk.nvim',
  cmd = 'QMKFormat',
  config = function()
    ---@type qmk.UserConfig
    local conf = {
      name = 'LAYOUT_5x6_5',
      layout = {
        '_ _ x x x x x x _ x x x x x x _ _',
        '_ _ x x x x x x _ x x x x x x _ _',
        '_ _ x x x x x x _ x x x x x x _ _',
        '_ _ x x x x x x _ x x x x x x _ _',
        '_ _ x x _ x x x _ x x x _ x x _ _',
        '_ _ _ _ _ _ x x _ x x _ _ _ _ _ _',
      },
    }
    require('qmk').setup(conf)
  end,
}
