local M = {}
local settings = require 'portal.settings'

---@type Portal.QueryGenerator
local function generator(opts, sett)
  local Content = require 'portal.content'
  local Iterator = require 'portal.iterator'
  local Search = require 'portal.search'

  local ok, common = pcall(require, 'trailblazer.trails.common')
  if not ok then
    return require('portal.log').error "Unable to load 'trailblazer'. Please ensure that trailblazer.nvim is installed."
  end

  opts = vim.tbl_extend('force', {
    direction = 'forward',
    max_results = #sett.labels,
  }, opts or {})

  if sett.max_results then
    opts.max_results = math.min(opts.max_results, sett.max_results)
  end

  local marks = common.get_trail_mark_stack_subset_for_buf()

  local iter = Iterator:new(marks):take(sett.lookback)

  if opts.start then
    iter = iter:start_at(opts.start)
  end

  if opts.direction == Search.direction.backward then
    iter = iter:reverse()
  end

  iter = iter:map(function(mark)
    if not mark.pos then
      return nil
    end

    local buffer = mark.buf

    return Content:new {
      type = 'trailblazer',
      buffer = buffer,
      cursor = { row = mark.pos[1], col = mark.pos[2] },
      callback = function(content)
        common.focus_win_and_buf_by_trail_mark_index(buffer, content.extra.mark_id, false)
      end,
      extra = {
        mark_id = mark.mark_id,
        file = vim.fn.bufname(buffer),
      },
    }
  end)

  iter = iter:filter(function(v)
    return vim.api.nvim_buf_is_valid(v.buffer)
  end)

  if sett.filter then
    iter = iter:filter(sett.filter)
  end

  if opts.filter then
    iter = iter:filter(opts.filter)
  end

  if not opts.slots then
    iter = iter:take(opts.max_results)
  end

  return {
    source = iter,
    slots = opts.slots,
  }
end

function M.query(opts)
  return generator(opts or {}, settings)
end

return M
