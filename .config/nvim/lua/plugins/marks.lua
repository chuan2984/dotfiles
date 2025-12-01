return {
  {
    'LeonHeidelbach/trailblazer.nvim',
    keys = {
      {
        '<leader>Ma',
        mode = 'n',
        function()
          vim.ui.input({ prompt = 'Stack name: ' }, function(input)
            if input then
              require('trailblazer').add_trail_mark_stack(input)
              require('trailblazer').switch_trail_mark_stack(input, true)
            end
          end)
        end,
        desc = 'Add trailmark stack',
      },
      {
        '<leader>MD',
        mode = 'n',
        function()
          require('trailblazer').delete_all_trail_mark_stacks(true)
        end,
        desc = 'Delete all trailmark stacks',
      },
      {
        '<leader>Ml',
        mode = 'n',
        function()
          -- TODO: need a better way to get the numb>, this reports stacks from Storage, only refreshes after switched
          local stacks = require('trailblazer.trails').stacks.trail_mark_stack_list
          local sorted_stacks = require('trailblazer.trails').stacks.get_sorted_stack_names()
          local current_stack = require('trailblazer.trails').stacks.current_trail_mark_stack_name
          vim.ui.select(sorted_stacks, {
            prompt = 'Choose a stack ',
            format_item = function(item)
              local fitem = item
              local count = vim.tbl_count(stacks[item] and stacks[item].stack or {})
              if item == current_stack then
                fitem = ' ' .. fitem
              end
              fitem = string.sub(' ', #tostring(vim.fn.index(sorted_stacks, item) + 1), 1) .. fitem -- left align
              return count > 0 and fitem .. string.format(' (%d)', count) or fitem -- add trails count if more than zero
            end,
          }, function(choice)
            if choice then
              require('trailblazer').switch_trail_mark_stack(choice)
            end
          end)
        end,
        desc = 'Switch trailmark stack',
      },
      {
        '<leader>Md',
        mode = 'n',
        function()
          local stacks = require('trailblazer.trails').stacks.get_sorted_stack_names()
          local current_stack = require('trailblazer.trails').stacks.current_trail_mark_stack_name
          stacks = vim.tbl_filter(function(stack)
            return stack ~= current_stack
          end, stacks)
          vim.ui.select(stacks, { prompt = 'Delete stack ' }, function(choice)
            if choice then
              require('trailblazer').delete_trail_mark_stack(choice)
            end
          end)
        end,
        desc = 'Delete trailmark stack',
      },
    },
    -- INFO: cannot lazy load if autoload on enter
    lazy = false,
    config = function()
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
              new_trail_mark = '<leader>mt',
              track_back = '<leader>mp',
              peek_move_next_down = '<leader>mi',
              peek_move_previous_up = '<leader>mo',
              move_to_nearest = '<leader>mn',
              toggle_trail_mark_list = '<leader>ml',
            },
            actions = {
              delete_all_trail_marks = '<leader>mD',
              paste_at_last_trail_mark = '<leader>mPl',
              paste_at_all_trail_marks = '<leader>mPa',
              set_trail_mark_select_mode = '<leader>msm',
              switch_to_next_trail_mark_stack = '<leader>Mn',
              switch_to_previous_trail_mark_stack = '<leader>Mp',
              set_trail_mark_stack_sort_mode = '<leader>Mss',
            },
          },
        },
      }
    end,
  },
  'EvWilson/spelunk.nvim',
  config = function()
    require('spelunk').setup {
      enable_persist = true,
    }
  end,
}
