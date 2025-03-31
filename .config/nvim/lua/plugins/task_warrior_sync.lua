return {
  'huantrinh1802/m_taskwarrior_d.nvim',
  version = '*',
  dependencies = { 'MunifTanjim/nui.nvim' },
  ft = 'markdown',
  keys = {
    {
      '<leader>twe',
      mode = 'n',
      '<cmd>TWEditTask<cr>',
      desc = '[t]ask[w]arrior [e]dit current task',
    },
    {
      '<leader>twv',
      mode = 'n',
      '<cmd>TWView<cr>',
      desc = '[t]ask[w]arrior detailed [v]iew',
    },
    {
      '<leader>twu',
      mode = 'n',
      '<cmd>TWUpdateCurrent<cr>',
      desc = '[t]ask[w]arrior [u]pdate current task',
    },
    {
      '<leader>tws',
      mode = 'n',
      '<cmd>TWSyncTasks<cr>',
      desc = '[t]ask[w]arrior [s]ync current buffer',
    },
    {
      '<leader>twt',
      mode = 'n',
      '<cmd>TWToggle<cr>',
      desc = '[t]ask[w]arrior [t]oggle current task',
    },
  },
  config = true,
}
