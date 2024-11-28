return {
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    { 'kristijanhusak/vim-dadbod-completion', lazy = true },
    { 'tpope/vim-dadbod', lazy = true },
  },
  cmd = {
    'DBUI',
    'DBUIToggle',
    'DBUIAddConnection',
    'DBUIFindBuffer',
  },
  init = function()
    vim.g.dbs = {
      {
        name = 'api_postgres',
        url = 'postgresql://pgu:this_is_a_password@localhost:5432/postgres',
      },
      {
        name = 'api_dev',
        url = 'postgresql://pgu:this_is_a_password@localhost:5432/fieldwire_api_development',
      },
      {
        name = 'api_redis',
        url = 'redis://localhost:6379',
      },
    }

    -- Your DBUI configuration
    vim.g.db_ui_use_nerd_fonts = 1
  end,
}
