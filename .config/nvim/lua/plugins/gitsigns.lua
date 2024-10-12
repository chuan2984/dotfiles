return {
  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    opts = {
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '󰐊' },
        topdelete = { text = '󰐊' },
        changedelete = { text = '▎' },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, desc = 'Go to the next hunk' })

        map('n', '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, desc = 'Go to the previous hunk' })

        -- Actions
        map('n', '<leader>hs', gs.stage_hunk, { desc = '[H]unk [S]tage' })
        map('n', '<leader>hr', gs.reset_hunk, { desc = '[H]unk [R]eset' })
        map('v', '<leader>hs', function()
          gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = '[H]unk [S]tage' })
        map('v', '<leader>hr', function()
          gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = '[H]unk [R]eset' })
        map('n', '<leader>hS', gs.stage_buffer, { desc = '[H]unk [S]tage buffer' })
        map('n', '<leader>hu', gs.undo_stage_hunk, { desc = '[H]unk [U]ndo last' })
        map('n', '<leader>hR', gs.reset_buffer, { desc = '[H]unk [R]eset buffer' })
        map('n', '<leader>hp', gs.preview_hunk, { desc = '[H]unk [P]review' })
        map('n', '<leader>hb', function()
          gs.blame_line { full = true }
        end, { desc = '[H]unk [B]lame' })
        map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = '[T]oggle [B]lame line' })
        map('n', '<leader>hd', gs.diffthis, { desc = '[H]unk [D]iff this index' })
        map('n', '<leader>hD', function()
          gs.diffthis '~'
        end, { desc = '[H]unk [D]iff this commit' })
        map('n', '<leader>td', gs.toggle_deleted, { desc = '[H]unk toggle [D]eleted' })

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'inside hunk' })
      end,
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et
