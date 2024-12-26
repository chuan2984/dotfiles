return {
  {
    -- 'hrsh7th/nvim-cmp',
    'iguanacucumber/magazine.nvim',
    name = 'nvim-cmp', -- Otherwise highlighting gets messed up
    event = { 'InsertEnter', 'CmdLineEnter' },
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        lazy = true,
        build = (function()
          -- Build Step is needed for regex support in snippets
          -- This step is not supported in many windows environments
          -- Remove the below condition to re-enable on windows
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
      },
      -- TODO: change it back when rspec snippets are merged { 'rafamadriz/friendly-snippets', lazy = true },
      { 'chuan2984/friendly-snippets', lazy = true, branch = 'rspec_snippets' },
      { 'saadparwaiz1/cmp_luasnip', lazy = true },
      { 'hrsh7th/cmp-cmdline', lazy = true },
      { 'hrsh7th/cmp-nvim-lsp', lazy = true },
      { 'hrsh7th/cmp-path', lazy = true },
      { 'hrsh7th/cmp-buffer', lazy = true },
    },
    config = function()
      vim.opt.completeopt = { 'menuone', 'noselect' }
      local compare = require('cmp').config.compare

      local kind_icons = {
        Text = '',
        Method = 'm',
        Function = '󰊕',
        Constructor = '',
        Field = '',
        Variable = '󰫧',
        Class = '',
        Interface = '',
        Module = '',
        Property = '',
        Unit = '',
        Value = '',
        Enum = '',
        Keyword = '',
        Snippet = '',
        Color = '',
        File = '',
        Reference = '',
        Folder = '',
        EnumMember = '',
        Constant = '',
        Struct = '',
        Event = '',
        Operator = '',
        TypeParameter = '󰊄',
      }
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'

      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
          { { name = 'path' } },
          { { name = 'cmdline', option = { ignore_cmds = { 'Man', '!' } } } }
        ),
        enabled = function()
          -- Set of commands where cmp will be disabled
          local disabled = {
            IncRename = true,
          }
          -- Get first word of cmdline
          local cmd = vim.fn.getcmdline():match '%S+'
          -- Return true if cmd isn't disabled
          -- else call/return cmp.close(), which returns false
          return not disabled[cmd] or cmp.close()
        end,
      })

      cmp.setup.filetype({ 'sql' }, {
        sources = {
          { name = 'vim-dadbod-completion' },
          { name = 'buffer' },
        },
      })

      local loader = require 'luasnip.loaders.from_vscode'
      loader.lazy_load()
      luasnip.filetype_extend('ruby', { 'rdoc', 'rspec' })
      luasnip.filetype_extend('lua', { 'luadoc' })

      vim.api.nvim_create_user_command('DebugSnippets', function()
        print 'Available snippets:'
        print(vim.inspect(luasnip.available()))
      end, {})

      cmp.setup {
        enabled = function()
          local context = require 'cmp.config.context'
          local line_to_cursor = vim.api.nvim_get_current_line():sub(1, vim.api.nvim_win_get_cursor(0)[2])

          -- Keep command mode completion enabled
          if vim.api.nvim_get_mode().mode == 'c' then
            return true
          end

          -- Check for common comment indicators at the start of the line
          local comment_indicators = {
            '^%s*%--', -- Lua
            '^%s*//', -- JavaScript, C, C++, etc.
            '^%s*#', -- Python, Bash, etc.
          }

          --- enable for the start of comment for comment snippets
          for _, pattern in ipairs(comment_indicators) do
            if line_to_cursor:match(pattern) then
              return true
            end
          end

          -- Disable in other comments
          return not context.in_treesitter_capture 'comment' and not context.in_syntax_group 'Comment'
        end,

        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        -- Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert {
          -- Select the [n]ext item
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        },
        formatting = {
          fields = { 'kind', 'abbr', 'menu' },
          expandable_indicator = true,
          format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
            vim_item.menu = ({
              lazydev = '[LazyDev]',
              nvim_lsp = '[LSP]',
              luasnip = '[Snippet]',
              buffer = '[Buffer]',
              path = '[Path]',
              cmdline = '[CMD]',
              natdat = '[DATE]',
              jupynium = '[Jupy]',
              dotenv = '[ENV]',
              ['vim-dadbod-completion'] = '[DB]',
            })[entry.source.name]
            return vim_item
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        sources = {
          { name = 'nvim_lsp', priority = 100 },
          { name = 'lazydev', group_index = 0, priority = 99 },
          { name = 'buffer', priority = 80 },
          { name = 'path', priority = 50 },
          { name = 'luasnip', priority = 50 },
          { name = 'jupynium', priority = 1000 },
        },
        sorting = {
          priority_weight = 1.0,
          comparators = {
            compare.score,
            compare.recently_used,
            compare.locality,
          },
        },
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
