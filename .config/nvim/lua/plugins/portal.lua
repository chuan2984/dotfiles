return {
  'cbochs/portal.nvim',
  cmd = 'Portal',
  keys = {
    {
      '<leader>pb',
      function()
        local recent_buffers = require 'plugins.portals.recent_buffers'
        require('portal').tunnel(recent_buffers.query { max_results = 5 })
      end,
      desc = '[p]ortal recent [b]uffers',
    },
    {
      '<leader>pi',
      function()
        require('portal.builtin').jumplist.tunnel_forward()
      end,
      desc = '[p]ortal jumplist prev',
    },
    {
      '<leader>po',
      function()
        require('portal.builtin').jumplist.tunnel_forward()
      end,
      desc = '[p]ortal jumplist next',
    },
  },
  config = function()
    require('portal').setup()
  end,
}
