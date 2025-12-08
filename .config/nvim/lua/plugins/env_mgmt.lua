return {
  'philosofonusus/ecolog.nvim',
  keys = {
    { '<leader>ek', '<cmd>EcologPeek<cr>', desc = 'Ecolog peek variable' },
    { '<leader>eg', '<cmd>EcologGotoVar<cr>', desc = 'Ecolog go to env variable' },
    { '<leader>es', '<cmd>EcologSelect<cr>', desc = 'Switch env file' },
  },
  -- Lazy loading is done internally
  lazy = false,
  opts = {
    integrations = {
      blink_cmp = true,
    },
    -- Enables shelter mode for sensitive values
    shelter = {
      modules = {
        cmp = false, -- Enabled to mask values in completion
        peek = false, -- Enable to mask values in peek view
        files = false, -- Enabled to mask values in file buffers
        telescope = false, -- Enable to mask values in telescope integration
        telescope_previewer = false, -- Enable to mask values in telescope preview buffers
        fzf = false, -- Enable to mask values in fzf picker
        fzf_previewer = false, -- Enable to mask values in fzf preview buffers
        snacks_previewer = false, -- Enable to mask values in snacks previewer
        snacks = false, -- Enable to mask values in snacks picker
      },
    },
    -- true by default, enables built-in types (database_url, url, etc.)
    types = true,
    path = vim.fn.getcwd(), -- Path to search for .env files
    preferred_environment = 'development', -- Optional: prioritize specific env files
    -- Controls how environment variables are extracted from code and how cmp works
    provider_patterns = true, -- true by default, when false will not check provider patterns
  },
}
