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
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        --  Useful when your language has ways of declaring types without an actual implementation.
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        --  Useful when you are not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        map('K', vim.lsp.buf.hover, 'Hover Documentation')

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and vim.lsp.inlay_hint then
          vim.lsp.inlay_hint.enable(true)
        end
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        if client and client.server_capabilities.documentHighlightProvider then
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end,
    })

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

    -- LSP servers and clients are able to communicate to each other what features they support.
    --  By default, Neovim doesn't support everything that is in the LSP Specification.
    --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
    --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
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
          '/users/chuanhe/.rbenv/shims/bundle',
          'exec',
          '--gemfile',
          '/users/chuanhe/github/work/fieldwire_api/.ruby-lsp/Gemfile',
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
      lua_ls = {},
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
        cmd = {
          vim.fs.joinpath(vim.fn.exepath 'lexical', 'libexec', 'lexical', 'bin', 'start_lexical.sh'),
        },
      },
      ['markdown-oxide'] = {},
    }

    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    local ensure_installed = vim.tbl_keys(servers or {})
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    require('mason-lspconfig').setup {
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          -- This handles overriding only values explicitly passed
          -- by the server configuration above. Useful when disabling
          -- certain features of an LSP (for example, turning off formatting for tsserver)
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }
  end,
}

-- vim: ts=2 sts=2 sw=2 et
