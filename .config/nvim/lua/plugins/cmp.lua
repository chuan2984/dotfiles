return {
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
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
      { 'rafamadriz/friendly-snippets', lazy = true },
      { 'saadparwaiz1/cmp_luasnip', lazy = true },
      { 'hrsh7th/cmp-cmdline', lazy = true },
      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      { 'hrsh7th/cmp-nvim-lsp', lazy = true },
      { 'hrsh7th/cmp-path', lazy = true },
      { 'SergioRibera/cmp-dotenv', lazy = true },
      { 'hrsh7th/cmp-buffer', lazy = true },
      { 'Gelio/cmp-natdat', lazy = true, config = true },
    },
    config = function()
      local kind_icons = {
        Text = '\u{eb69}',
        Method = 'm',
        Function = '\u{f0295}',
        Constructor = '',
        Field = '',
        Variable = '\u{f0ae7}',
        Class = '\u{eb5b}',
        Interface = '',
        Module = '',
        Property = '',
        Unit = '',
        Value = '\u{f4f7}',
        Enum = '',
        Keyword = '',
        Snippet = '',
        Color = '\u{eb5c}',
        File = '\u{ea7b}',
        Reference = '',
        Folder = '\u{ea83}',
        EnumMember = '',
        Constant = '\u{eb5d}',
        Struct = '',
        Event = '',
        Operator = '\u{eb64}',
        TypeParameter = '\u{f0284}',
      }
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'

      luasnip.filetype_extend('ruby', { 'rails' })
      require('luasnip.loaders.from_vscode').lazy_load { include = { 'ruby', 'rails' } }
      luasnip.config.setup {}
      -- `:` cmdline setup.
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline', max_item_count = 16, option = { ignore_cmds = { 'Man', '!' } } } }),
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

      cmp.setup {

        enabled = function()
          -- disable completion in comments
          local context = require 'cmp.config.context'
          -- keep command mode completion enabled when cursor is in a comment
          if vim.api.nvim_get_mode().mode == 'c' then
            return true
          else
            return not context.in_treesitter_capture 'comment' and not context.in_syntax_group 'Comment'
          end
        end,

        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert {
          -- Select the [n]ext item
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ['<C-y>'] = cmp.mapping.confirm { select = true },

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-Space>'] = cmp.mapping.complete {},

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
              nvim_lsp = '[LSP]',
              nvim_lua = '[NVIM_LUA]',
              luasnip = '[Snippet]',
              buffer = '[Buffer]',
              path = '[Path]',
              cmdline = '[CMD]',
              natdat = '[DATE]',
              dotenv = '[ENV]',
            })[entry.source.name]
            return vim_item
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        sources = {
          { name = 'lazydev', group_index = 0 },
          { name = 'nvim_lsp', max_item_count = 10 },
          { name = 'luasnip', max_item_count = 10 },
          { name = 'path', max_item_count = 6 },
          { name = 'buffer', max_item_count = 6 },
          { name = 'nvim_lua', max_item_count = 20 },
          { name = 'buffer', max_item_count = 4 },
          { name = 'natdat' },
          -- { name = 'dotenv', max_item_count = 10 },
        },
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
