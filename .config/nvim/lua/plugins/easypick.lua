return {
  'chuan2984/easypick.nvim',
  dependencies = 'nvim-telescope/telescope.nvim',
  cmd = 'Easypick',
  config = function()
    local easypick = require 'easypick'

    -- only required for the example to work
    -- local get_default_branch = "git rev-parse --symbolic-full-name refs/remotes/origin/HEAD | sed 's!.*/!!'"
    local get_default_branch = "git remote show origin | grep 'HEAD branch' | cut -d' ' -f5"
    local base_branch = vim.fn.system(get_default_branch) or 'main'

    easypick.setup {
      pickers = {
        {
          -- name for your custom picker, that can be invoked using :Easypick <name> (supports tab completion)
          name = 'pwd',
          -- the command to execute, output has to be a list of plain text entries
          command = 'pwd',
          -- specify your custom previewer, or use one of the easypick.previewers
          previewer = easypick.previewers.default(),
        },
        {
          name = 'changed_files',
          command = 'git diff --name-only $(git merge-base HEAD ' .. base_branch .. ' )',
          previewer = easypick.previewers.branch_diff { base_branch = base_branch },
          action = easypick.actions.nvim_commandf 'edit %s',
        },
        {
          name = 'conflicts',
          command = 'git diff --name-only --diff-filter=U --relative',
          previewer = easypick.previewers.file_diff(),
          action = easypick.actions.nvim_commandf 'edit %s',
        },
      },
    }
  end,
}
