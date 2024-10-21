-- TODO: add telescope extension and statusline maybe?
return {
  'LeonHeidelbach/trailblazer.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  config = function()
    local colors = require('catppuccin.palettes').get_palette 'macchiato' -- fetch colors from palette
    require('trailblazer').setup {
      auto_save_trailblazer_state_on_exit = true,
      auto_load_trailblazer_state_on_enter = true,
      trail_options = {
        -- The trail mark priority sets the global render priority of trail marks in the sign/number
        -- column as well as the highlights within the text (e.g. Treesitter sets a value of 100).
        -- Make sure this value is higher than any other plugin you use to ensure that trail marks
        -- are always visible and don't get overshadowed.
        trail_mark_priority = 10001,
        -- Available modes to cycle through. Remove any you don't need.
        available_trail_mark_modes = {
          'global_chron',
          'global_buf_line_sorted',
          'global_fpath_line_sorted',
          'global_chron_buf_line_sorted',
          'global_chron_fpath_line_sorted',
          'global_chron_buf_switch_group_chron',
          'global_chron_buf_switch_group_line_sorted',
          'buffer_local_chron',
          'buffer_local_line_sorted',
        },
        -- The current / initially selected trail mark selection mode. Choose from one of the
        -- available modes: global_chron, global_buf_line_sorted, global_chron_buf_line_sorted,
        -- global_chron_buf_switch_group_chron, global_chron_buf_switch_group_line_sorted,
        -- buffer_local_chron, buffer_local_line_sorted
        current_trail_mark_mode = 'global_chron',
        mark_symbol = '•', --  will only be used if trail_mark_symbol_line_indicators_enabled = true
        newest_mark_symbol = '󰎔', -- disable this mark symbol by setting its value to ""
        cursor_mark_symbol = '󰁖', -- disable this mark symbol by setting its value to ""
        next_mark_symbol = '󰙡', -- disable this mark symbol by setting its value to ""
        previous_mark_symbol = '󰙣', -- disable this mark symbol by setting its value to ""
        multiple_mark_symbol_counters_enabled = false,
        number_line_color_enabled = true,
        trail_mark_in_text_highlights_enabled = false,
        trail_mark_symbol_line_indicators_enabled = false, -- show indicators for all trail marks in symbol column
        symbol_line_enabled = true,
        default_trail_mark_stacks = {
          -- this is the list of trail mark stacks that will be created by default. Add as many
          -- as you like to this list. You can always create new ones in Neovim by using either
          -- `:TrailBlazerSwitchTrailMarkStack <name>` or `:TrailBlazerAddTrailMarkStack <name>`
          'default', -- , "stack_2", ...
        },
        available_trail_mark_stack_sort_modes = {
          'alpha_asc', -- alphabetical ascending
          'alpha_dsc', -- alphabetical descending
          'chron_asc', -- chronological ascending
          'chron_dsc', -- chronological descending
        },
        -- The current / initially selected trail mark stack sort mode. Choose from one of the
        -- available modes: alpha_asc, alpha_dsc, chron_asc, chron_dsc
        current_trail_mark_stack_sort_mode = 'alpha_asc',
        -- Set this to true if you always want to move to the nearest trail mark first before
        -- continuing to peek move in the current selection mode order. This effectively disables
        -- the "current trail mark cursor" to which you would otherwise move first before continuing
        -- to move through your trail mark stack.
        move_to_nearest_before_peek = false,
        move_to_nearest_before_peek_motion_directive_up = 'fpath_up', -- "up", "fpath_up" -> For more information see section "TrailBlazerMoveToNearest Motion Directives"
        move_to_nearest_before_peek_motion_directive_down = 'fpath_down', -- "down", "fpath_down" -> For more information see section "TrailBlazerMoveToNearest Motion Directives"
        move_to_nearest_before_peek_dist_type = 'lin_char_dist', -- "man_dist", "lin_char_dist" -> Manhattan Distance or Linear Character Distance
      },
      event_list = {
        -- Add the events you would like to add custom callbacks for here. For more information see section "Custom Events"
        -- "TrailBlazerTrailMarkStackSaved",
        -- "TrailBlazerTrailMarkStackDeleted",
        -- "TrailBlazerCurrentTrailMarkStackChanged",
        -- "TrailBlazerTrailMarkStackSortModeChanged"
      },
      mappings = { -- rename this to "force_mappings" to completely override default mappings and not merge with them
        nv = { -- Mode union: normal & visual mode. Can be extended by adding i, x, ...
          motions = {
            new_trail_mark = '<c-s>',
            track_back = '<leader>mo',
            peek_move_next_down = '<leader>mn',
            peek_move_previous_up = '<leader>mp',
            move_to_nearest = '<leader>mi',
            toggle_trail_mark_list = '<leader>M',
          },
          actions = {
            delete_all_trail_marks = '<leader>Md',
            paste_at_last_trail_mark = '<leader>Mpl',
            paste_at_all_trail_marks = '<leader>Mpa',
            set_trail_mark_select_mode = '<leader>Msm',
            switch_to_next_trail_mark_stack = '<leader>Mn',
            switch_to_previous_trail_mark_stack = '<leader>Mp',
            set_trail_mark_stack_sort_mode = '<leader>Mss',
          },
        },
      },
      hl_groups = {
        TrailBlazerTrailMarkNext = {
          guifg = colors.green, -- #a6da95
          guibg = 'none',
        },
        TrailBlazerTrailMarkPrevious = {
          guifg = colors.peach, -- #f5a97f
          guibg = 'none',
        },
        TrailBlazerTrailMarkCursor = {
          guifg = colors.crust, -- #181926
          guibg = colors.overlay0,
        },
        TrailBlazerTrailMarkNewest = {
          guifg = colors.crust, -- #181926
          guibg = colors.sky,
        },
        TrailBlazerTrailMarkCustomOrd = {
          guifg = colors.crust, -- #181926
          guibg = colors.mauve, -- #c6a0f6
        },
        TrailBlazerTrailMarkGlobalChron = {
          guifg = colors.crust, -- #181926
          guibg = colors.red, -- #ed8796
        },
        TrailBlazerTrailMarkGlobalBufLineorted = {
          guifg = colors.crust, -- #181926
          guibg = colors.maroon, -- #ee99a0
        },
        TrailBlazerTrailMarkGlobalFpathLineSorted = {
          guifg = colors.crust, -- #181926
          guibg = colors.maroon, -- #ee99a0
        },
        TrailBlazerTrailMarkGlobalChronBufLineSorted = {
          guifg = colors.crust, -- #181926
          guibg = colors.yello, -- ##eed49f
        },
        TrailBlazerTrailMarkGlobalChronFpathLineSorted = {
          guifg = colors.crust, -- #181926
          guibg = colors.yello, -- ##eed49f
        },
        TrailBlazerTrailMarkGlobalChronBufSwitchGroupChron = {
          guifg = colors.crust, -- #181926
          guibg = colors.pink, -- #f5bde6
        },
        TrailBlazerTrailMarkGlobalChronBufSwitchGroupLineSorted = {
          guifg = colors.crust, -- #181926
          guibg = colors.sky, -- #91d7e3
        },
        TrailBlazerTrailMarkBufferLocalChron = {
          guifg = colors.crust, -- #181926
          guibg = colors.green, -- #a6da95
        },
        TrailBlazerTrailMarkBufferLocalLineSorted = {
          guifg = colors.crust, -- #181926
          guibg = colors.teal, -- #8bd5ca
        },
      },
    }
  end,
}
--
-- rosewater = "#f4dbd6",
-- flamingo = "#f0c6c6",
-- pink = "#f5bde6",
-- mauve = "#c6a0f6",
-- red = "#ed8796",
-- maroon = "#ee99a0",
-- peach = "#f5a97f",
-- yellow = "#eed49f",
-- green = "#a6da95",
-- teal = "#8bd5ca",
-- sky = "#91d7e3",
-- sapphire = "#7dc4e4",
-- blue = "#8aadf4",
-- lavender = "#b7bdf8",
-- text = "#cad3f5",
-- subtext1 = "#b8c0e0",
-- subtext0 = "#a5adcb",
-- overlay2 = "#939ab7",
-- overlay1 = "#8087a2",
-- overlay0 = "#6e738d",
-- surface2 = "#5b6078",
-- surface1 = "#494d64",
-- surface0 = "#363a4f",
-- base = "#24273a",
-- mantle = "#1e2030",
-- crust = "#181926",

-- 1. **`custom_ord`**:
--    - This mode is useful when you have manually rearranged the order of your trail marks, and you want to preserve that custom order when navigating through them.
--    - For example, if you're working on a complex project with many files, and you've carefully positioned your marks to represent the logical flow of your work, this mode will allow you to move through those marks in the order you've set, rather than the default chronological order.
--
-- 2. **`global_chron`**:
--    - This is the default mode, and it's useful when you want to navigate through your marks in the order they were created, regardless of which file they're in.
--    - This can be helpful when you're exploring a codebase or document and want to retrace your steps, jumping back to earlier points of interest.
--
-- 3. **`global_buf_line_sorted`**:
--    - This mode is useful when you want to navigate through your marks in a more organized, structured way, sorted first by the buffer (file) they're in, and then by the line number within that buffer.
--    - This can be helpful when you're working on a large codebase or document and want to quickly jump between marks in different files, while still maintaining a sense of the relative position of the marks within each file.
--
-- 4. **`global_fpath_line_sorted`**:
--    - Similar to the `global_buf_line_sorted` mode, this mode sorts the marks first by the file path (instead of just the buffer ID), and then by the line number.
--    - This can be useful when you're working on a project with a complex file structure and you want to navigate through your marks in a way that reflects the organization of your codebase or document.
--
-- 5. **`global_chron_buf_line_sorted`**:
--    - This mode combines the chronological ordering of `global_chron` with the buffer-and-line-based sorting of `global_buf_line_sorted`.
--    - This can be helpful when you want to navigate through your marks in a way that reflects both the order in which they were created and their relative position within each file.
--
-- 6. **`global_chron_fpath_line_sorted`**:
--    - This mode is similar to `global_chron_buf_line_sorted`, but it uses the file path instead of the buffer ID for the secondary sorting.
--    - This can be useful when you want to navigate through your marks in a way that reflects both the order in which they were created and their relative position within the overall file structure of your project.
--
-- 7. **`global_chron_buf_switch_group_chron`**:
--    - This mode groups the marks by the buffer switch events, and then traverses the marks within each group in chronological order.
--    - This can be helpful when you're working on a project with frequent context switching between different files, and you want to efficiently navigate through the marks associated with each context.
--
-- 8. **`global_chron_buf_switch_group_line_sorted`**:
--    - This mode is similar to `global_chron_buf_switch_group_chron`, but it sorts the marks within each group by line number instead of chronological order.
--    - This can be useful when you want to maintain the chronological order of the marks across buffer switches, but also have the ability to quickly jump to specific positions within each buffer.
--
-- 9. **`buffer_local_chron`**:
--    - This mode only considers the marks within the current buffer, and traverses them in chronological order.
--    - This can be helpful when you're focused on a specific file and want to quickly navigate through the marks you've created within that context, without being distracted by marks from other files.
--
-- 10. **`buffer_local_line_sorted`**:
--     - This mode is similar to `buffer_local_chron`, but it sorts the marks within the current buffer by line number instead of chronological order.
--     - This can be useful when you want to quickly jump between specific positions within the current file, without having to worry about the order in which the marks were created.
