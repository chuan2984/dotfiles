return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    -- Useful status updates for LSP.
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    { 'j-hui/fidget.nvim', opts = {} },
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map('gd', function()
          Snacks.picker.lsp_definitions()
        end, '[G]oto [D]efinition')
        map('gD', function()
          Snacks.picker.lsp_declarations()
        end, '[G]oto [D]eclaration')
        map('gr', function()
          Snacks.picker.lsp_references()
        end, '[G]oto [R]eferences')
        --  Useful when your language has ways of declaring types without an actual implementation.
        map('gI', function()
          Snacks.picker.lsp_implementations()
        end, '[G]oto [I]mplementation')
        --  Useful when you are not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        map('<leader>gy', function()
          Snacks.picker.lsp_type_definitions()
        end, 'Type [D]efinition')
        map('<leader>ss', function()
          Snacks.picker.lsp_symbols()
        end, 'LSP [S]ymbols')
        map('<leader>sS', function()
          Snacks.picker.lsp_workspace_symbols()
        end, 'LSP Workspace Symbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
        map('K', vim.lsp.buf.hover, 'Hover Documentation')

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
          vim.lsp.inlay_hint.enable(true)
        end

        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })
        end

        vim.api.nvim_create_autocmd('LspDetach', {
          group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            pcall(vim.api.nvim_clear_autocmds, { group = 'kickstart-lsp-highlight', buffer = event2.buf })
          end,
        })
      end,
    })

    -- Diagnostic Config
    -- See :help vim.diagnostic.Opts
    vim.diagnostic.config {
      severity_sort = true,
      float = { border = 'rounded', source = 'if_many' },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅚 ',
          [vim.diagnostic.severity.WARN] = '󰀪 ',
          [vim.diagnostic.severity.INFO] = '󰋽 ',
          [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
      } or {},
      virtual_text = {
        source = 'if_many',
        spacing = 2,
        format = function(diagnostic)
          local diagnostic_message = {
            [vim.diagnostic.severity.ERROR] = diagnostic.message,
            [vim.diagnostic.severity.WARN] = diagnostic.message,
            [vim.diagnostic.severity.INFO] = diagnostic.message,
            [vim.diagnostic.severity.HINT] = diagnostic.message,
          }
          return diagnostic_message[diagnostic.severity]
        end,
      },
    }

    require('mason').setup()

    local function add_ruby_deps_command(client, bufnr)
      vim.api.nvim_buf_create_user_command(bufnr, 'ShowRubyDeps', function(opts)
        local params = vim.lsp.util.make_text_document_params()
        local showAll = opts.args == 'all'

        client.request('rubyLsp/workspace/dependencies', params, function(error, result)
          if error then
            print('Error showing deps: ' .. error)
            return
          end

          local qf_list = {}
          for _, item in ipairs(result) do
            if showAll or item.dependency then
              table.insert(qf_list, {
                text = string.format('%s (%s) - %s', item.name, item.version, item.dependency),
                filename = item.path,
              })
            end
          end

          vim.fn.setqflist(qf_list)
          vim.cmd 'copen'
        end, bufnr)
      end, {
        nargs = '?',
        complete = function()
          return { 'all' }
        end,
      })
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- add folding
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    local servers = {
      ruby_lsp = {
        cmd = {
          os.getenv 'HOME' .. '/.rbenv/shims/bundle',
          'exec',
          '--gemfile',
          os.getenv 'HOME' .. '/github/work/fieldwire_api/.ruby-lsp/Gemfile',
          'ruby-lsp',
        },
        on_attach = function(client, buffer)
          add_ruby_deps_command(client, buffer)
        end,
        init_options = {
          enabledFeatures = {
            codeLens = false,
            semanticHighlighting = false,
          },
          indexing = {
            excludedPatterns = {
              '**/spec**',
              '**/test**',
              '**/vendor**',
              '**/circleci_scripts**',
              '**/coverage**',
              '**/docker_files**',
              '**/notes**',
              '**/docs**',
              '**/tmp**',
              '**/swagger**',
              '**/spikes**',
            },
            includedPatterns = {
              '**/*.rb',
            },
            excludedGems = {
              'google-api-client',
              'rubocop',
              'graphql',
              'faker',
              'aws-sdk',
              'opensearch-api',
              'capybara',
              'brakeman',
              'pry',
              'byebug',
              'shoulda-matchers',
              'pry',
              'rubocop-rails',
              'rubocoprspec',
              'railties',
              'elasticsearch-dsl',
              'rdoc',
              'openapi3_parser',
              'mail',
              'test-prof',
              'stripe',
              'rubocop-ast',
              'browser',
              'rspec-rails',
              'sentry-ruby',
              'ttfunk',
              'aws-sdk-kms',
              'aws-sdk-s3',
              'aws-sdk-sns',
              'aws-sdk-sqs',
              'aws-sdk-textract',
            },
          },
          formatter = 'rubocop_internal',
          linters = { 'rubocop_internal' },
          experimentalFeaturesEnabled = false,
        },
      },
      clangd = {},
      lua_ls = {
        settings = {
          Lua = {
            format = { enable = false },
          },
        },
      },
      stylua = {},
      markdownlint = {},
      harper_ls = {
        settings = {
          ['harper-ls'] = {
            linters = {
              ToDoHyphen = false,
              SpellCheck = false,
              SentenceCapitalization = false,
              LongSentences = false,
            },
            markdown = {
              IgnoreLinkTitle = false,
            },
            userDictPath = '~/dotfiles/.config/nvim/spell/en.utf-8.add',
          },
        },
      },
      lexical = {
        root_dir = function(fname)
          return require('lspconfig').util.root_pattern('mix.exs', '.git')(fname) or vim.loop.cwd()
        end,
        filetypes = { 'elixir', 'eelixir', 'heex' },
        -- cmd = {
        --   vim.fs.joinpath(vim.fn.exepath 'lexical', 'libexec', 'lexical', 'bin', 'start_lexical.sh'),
        -- },
      },
      ['markdown-oxide'] = {},
    }

    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    local ensure_installed = vim.tbl_keys(servers or {})
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    ---@type MasonLspconfigSettings
    ---@diagnostic disable-next-line: missing-fields
    require('mason-lspconfig').setup {
      automatic_enable = vim.tbl_keys(servers or {}),
    }

    for server_name, config in pairs(servers) do
      config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, config.capabilities or {})
      vim.lsp.config(server_name, config)
    end
  end,
}

-- vim: ts=2 sts=2 sw=2 et
