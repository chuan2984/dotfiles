return {
  {
    'NickvanDyke/opencode.nvim',
    lazy = false,
    dependencies = {
      {
        'folke/snacks.nvim',
        opts = {
          input = {
            enabled = true, -- Enhances Ask
          },
          picker = {
            enabled = true, -- Enhances Select
            win = {
              input = {
                keys = {
                  ['<a-a>'] = { 'opencode_send', mode = { 'n', 'i' } },
                },
              },
            },
            actions = {
              opencode_send = function(picker) ---@param picker snacks.Picker
                local items = vim.tbl_map(function(item) ---@param item snacks.picker.Item
                  return item.file
                      and require('opencode').format { path = item.file, from = item.pos, to = item.end_pos }
                    or item.text
                end, picker:selected { fallback = true })

                require('opencode').prompt(table.concat(items, ', ') .. ' ')
              end,
            },
          },
        },
      },
    },
    keys = {
      {
        '<c-g>g',
        function()
          require('opencode').ask '@this: '
        end,
        mode = { 'n', 'x' },
        desc = 'Ask opencode',
      },
      {
        '<c-g>x',
        function()
          require('opencode').select()
        end,
        mode = { 'n', 'x' },
        desc = 'Execute opencode action…',
      },
      {
        '<c-g>a',
        function()
          require('opencode').prompt '@this'
        end,
        mode = { 'n', 'x' },
        desc = 'Add to opencode',
      },
      {
        '<c-g><C-u>',
        function()
          require('opencode').command 'session.half.page.up'
        end,
        mode = 'n',
        desc = 'opencode half page up',
      },
      {
        '<c-g><C-d>',
        function()
          require('opencode').command 'session.half.page.down'
        end,
        mode = 'n',
        desc = 'opencode half page down',
      },
    },
    config = function()
      local opencode_cmd = 'opencode --port'
      ---@type snacks.terminal.Opts
      local snacks_terminal_opts = {
        win = {
          position = 'right',
          enter = false,
        },
      }

      ---@type opencode.Opts
      vim.g.opencode_opts = {
        server = {
          start = function()
            require('snacks.terminal').open(opencode_cmd, snacks_terminal_opts)
          end,
        },
      }

      -- Can also leverage toggle functionality.
      -- If you use <leader> here, remove 't' — otherwise Neovim will add input delay to your <leader> when typing in the terminal to watch for the mapping.
      vim.keymap.set({ 'n', 't' }, '<C-g>;', function()
        require('snacks.terminal').toggle(opencode_cmd, snacks_terminal_opts)
      end, { desc = 'Toggle OpenCode' })

      -- Optionally show upon submitting prompt
      vim.api.nvim_create_autocmd('User', {
        pattern = { 'OpencodeEvent:tui.command.execute' },
        callback = function(args)
          ---@type opencode.server.Event
          local event = args.data.event
          if event.properties.command == 'prompt.submit' then
            local win = require('snacks.terminal').get(opencode_cmd, { create = false })
            if win then
              win:show()
            end
          end
        end,
      })
      -- Required for `opts.events.reload`.
      vim.o.autoread = true
    end,
  },
}
