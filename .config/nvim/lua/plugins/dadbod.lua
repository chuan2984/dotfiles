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
        name = 'api_dev',
        url = 'postgresql://pgu:this_is_a_password@localhost:5432/fieldwire_api_development',
      },
      {
        name = 'api_dev_replica',
        url = 'postgresql://pgu:this_is_a_password@localhost:6543/fieldwire_api_development',
      },
      {
        name = 'api_test',
        url = 'postgresql://pgu:this_is_a_password@localhost:5433/fieldwire_api_test',
      },
      {
        name = 'api_test_replica',
        url = 'postgresql://pgu:this_is_a_password@localhost:6544/fieldwire_api_test',
      },
      {
        name = 'api_valkey',
        url = 'redis://localhost:6379',
      },
      {
        name = 'api_redis',
        url = 'redis://localhost:6380',
      },
    }

    -- Your DBUI configuration
    vim.g.db_ui_use_nerd_fonts = 1
  end,
}
