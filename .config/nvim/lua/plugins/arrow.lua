return {
  'otavioschwanck/arrow.nvim',
  event = 'BufRead',
  opts = {
    show_icons = true,
    leader_key = "'", -- Recommended to be a single key
    buffer_leader_key = 'm', -- Per Buffer Mappings
    separate_by_branch = true,
  },
}