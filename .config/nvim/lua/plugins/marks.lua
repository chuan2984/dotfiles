return {
  {
    'EvWilson/spelunk.nvim',
    opts = {
      base_mappings = {
        delete = '<leader>br',
      },
      enable_persist = true,
      orientation = 'centered',
      style = {
        border = 'single', -- 'single', 'double', 'rounded', 'solid', 'none', or custom array
        border_hl = 'FloatBorder', -- Highlight group for borders
        title_pos = 'center', -- 'left', 'center', 'right'
        winblend = 0, -- 0-100, window transparency
        background_hl = nil, -- Highlight group for background (nil = default)
        -- Text highlights
        hl_stack_name = 'Title', -- Stack name in header
        hl_bookmark_idx = 'Number', -- Bookmark index numbers
        hl_bookmark_path = 'Normal', -- File paths
        hl_bookmark_alias = 'Comment', -- Bookmark aliases
      },
      enable_status_col_display = true,
      fuzzy_search_provider = 'snacks',
      statusline_prefix = '',
    },
    config = function(_, opts)
      local spelunk = require 'spelunk'

      local markmgr = require 'spelunk.markmgr'
      local set = require('spelunk.config').set_keymap

      -- Display filename and line (default) and optionally the bookmark name
      ---@diagnostic disable-next-line: duplicate-set-field
      spelunk.display_function = function(bookmark)
        local mark_idx = nil
        local mark_name = nil

        for i, mark_ in ipairs(markmgr.physical_stack(spelunk.get_current_stack_index()).bookmarks) do
          if mark_.file == bookmark.file and mark_.line == bookmark.line then
            mark_idx = i
            break
          end
        end

        if mark_idx then
          mark_name = markmgr.get_mark_meta(spelunk.get_current_stack_index(), mark_idx, 'alias')
        end

        if mark_name and mark_name ~= '' then
          return string.format('%s:%d [%s]', spelunk.filename_formatter(bookmark.file), bookmark.line, mark_name)
        end

        return string.format('%s:%d', spelunk.filename_formatter(bookmark.file), bookmark.line)
      end

      local add_mark_alias = function()
        local line = vim.fn.line '.'
        local mark_idx =
          markmgr.get_mark_idx_from_line(spelunk.get_current_stack_index(), vim.api.nvim_buf_get_name(0), line)
        if not mark_idx then
          vim.notify(string.format('[spelunk.nvim] Line %d does not have a bookmark', line), vim.log.levels.ERROR)
          return
        end

        local alias = vim.fn.input '[spelunk.nvim] Bookmark alias: '
        if alias and alias ~= '' then
          spelunk.add_mark_meta(spelunk.get_current_stack_index(), mark_idx, 'alias', alias)
        end
      end

      local add_mark_notes = function()
        local line = vim.fn.line '.'
        local mark_idx =
          markmgr.get_mark_idx_from_line(spelunk.get_current_stack_index(), vim.api.nvim_buf_get_name(0), line)
        if not mark_idx then
          vim.notify(string.format('[spelunk.nvim] Line %d does not have a bookmark', line), vim.log.levels.ERROR)
          return
        end

        -- Get existing note if any
        local existing_note = markmgr.get_mark_meta(spelunk.get_current_stack_index(), mark_idx, 'notes')
        if existing_note == nil then
          existing_note = ''
        end

        -- Create a floating buffer for multiline input
        local buf = vim.api.nvim_create_buf(false, true)
        local width = 80
        local height = 15

        -- Set buffer content to existing note
        if existing_note ~= '' then
          local lines = vim.split(existing_note, '\n', { plain = true })
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        end

        -- Create floating window
        local win = vim.api.nvim_open_win(buf, true, {
          relative = 'editor',
          width = width,
          height = height,
          col = math.floor((vim.o.columns - width) / 2),
          row = math.floor((vim.o.lines - height) / 2),
          border = 'rounded',
          title = ' Bookmark Notes ',
          title_pos = 'center',
          footer = ' <CR>:save | <Esc>:cancel ',
          footer_pos = 'center',
        })

        -- Set buffer options
        vim.bo[buf].buftype = 'nofile'
        vim.bo[buf].filetype = 'markdown'

        -- Set up keymaps for save and cancel
        local function save_note()
          local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
          local note = table.concat(lines, '\n')
          -- Ensure we always pass a string, even if empty
          spelunk.add_mark_meta(spelunk.get_current_stack_index(), mark_idx, 'notes', note or '')
          vim.api.nvim_win_close(win, true)
          vim.notify('[spelunk.nvim] Bookmark notes saved', vim.log.levels.INFO)
        end

        local function cancel()
          vim.api.nvim_win_close(win, true)
          vim.notify('[spelunk.nvim] Cancelled', vim.log.levels.INFO)
        end

        vim.keymap.set('n', '<CR>', save_note, { buffer = buf, nowait = true })
        vim.keymap.set('n', '<Esc>', cancel, { buffer = buf, nowait = true })
      end

      -- Show notes on hover/keypress
      local show_mark_notes_hover = function()
        local line = vim.fn.line '.'
        local mark_idx =
          markmgr.get_mark_idx_from_line(spelunk.get_current_stack_index(), vim.api.nvim_buf_get_name(0), line)
        if not mark_idx then
          return
        end

        local notes = markmgr.get_mark_meta(spelunk.get_current_stack_index(), mark_idx, 'notes') or ''
        local alias = markmgr.get_mark_meta(spelunk.get_current_stack_index(), mark_idx, 'alias') or ''
        local name = markmgr.get_mark_meta(spelunk.get_current_stack_index(), mark_idx, 'name') or ''

        if notes == '' and alias == '' and name == '' then
          return
        end

        local lines = {}
        if name ~= '' then
          table.insert(lines, '**Bookmark:** ' .. name)
        end
        if alias ~= '' then
          table.insert(lines, '**Alias:** ' .. alias)
        end
        if notes ~= '' then
          table.insert(lines, '')
          table.insert(lines, '**Notes:**')
          for _, note_line in ipairs(vim.split(notes, '\n', { plain = true })) do
            table.insert(lines, note_line)
          end
        end

        if #lines > 0 then
          vim.lsp.util.open_floating_preview(lines, 'markdown', {
            border = 'rounded',
            focusable = true,
            focus = false,
          })
        end
      end

      set('ma', add_mark_alias, '[spelunk.nvim] Edit bookmark alias')
      set('mn', add_mark_notes, '[spelunk.nvim] Edit bookmark notes')
      set('mh', show_mark_notes_hover, '[spelunk.nvim] Show bookmark notes hover')
      spelunk.setup(opts)
    end,
  },
}
