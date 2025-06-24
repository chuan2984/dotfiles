return {
  'MagicDuck/grug-far.nvim',
  -- NOTE: grug-far.lua defers all it's requires so it's lazy by default
  config = function()
    -- optional setup call to override plugin options
    -- alternatively you can set options with vim.g.grug_far = { ... }
    require('grug-far').setup {
      -- options, see Configuration section below
      -- there are no required options atm
    }
  end,
}
