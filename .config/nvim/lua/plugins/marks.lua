return {
  {
    'EvWilson/spelunk.nvim',
    config = function()
      local spelunk = require 'spelunk'
      spelunk.setup {
        enable_persist = true,
        enable_status_col_display = true,
        fuzzy_search_provider = 'snacks',
      }

      ---@diagnostic disable-next-line: duplicate-set-field
      spelunk.display_function = function(bookmark)
        local ctx = require('spelunk.util').get_treesitter_context(bookmark)
        dd(bookmark)
        ctx = (ctx == '' and ctx) or (' - ' .. ctx)
        dd(ctx)
        local filename = spelunk.filename_formatter(bookmark.file)
        return string.format('%s:%d%s', filename, bookmark.line, ctx)
      end
    end,
  },
}
