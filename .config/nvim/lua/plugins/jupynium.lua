return {
  'kiyoon/jupynium.nvim',
  -- NOTE: to install the dependencies, one needs to create a virtualenv with Python3
  -- or with conda. Navigate to where this plugin is installed, ~/.local/share/nvim/lazy/jupynium.nvim
  -- make sure you have virtualenv activated, then run `pip3 install .`
  -- to make jupynium available systemwide, you can add `alias jupynium={path_to_bin_in_venv}` to your .zshrc
  -- build = 'pip3 install --user .',
  cond = function()
    local cwd = vim.fn.getcwd()
    return cwd:match '/github/jupyter'
  end,
}