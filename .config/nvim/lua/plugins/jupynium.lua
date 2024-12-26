return {
  'kiyoon/jupynium.nvim',
  cmd = 'Jupynium',
  -- NOTE: to install the dependencies, one needs to create a virtualenv with Python3
  -- or with conda. Navigate to where this plugin is installed, ~/.local/share/nvim/lazy/jupynium.nvim
  -- make sure you have virtualenv activated, then run `pip3 install .`
  -- to make jupynium available systemwide, you can add `alias jupynium={path_to_bin_in_venv}` to your .zshrc
  -- build = 'pip3 install --user .',
  config = function()
    local cursorline_hl = vim.api.nvim_get_hl(0, { name = 'CursorLine' })
    local separator_bg = string.format('#%06x', cursorline_hl.bg - 0x101010)

    vim.api.nvim_set_hl(0, 'JupyniumMarkdownCellContent', {
      bg = separator_bg,
      fg = 'NONE',
    })
  end,
}
