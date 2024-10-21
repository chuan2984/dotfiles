local M = {}
local content = require 'portal.content'
local iterator = require 'portal.iterator'
local search = require 'portal.search'
local settings = require 'portal.settings'

local function buffer_generator(opts, setts)
  -- most of the stuff below is copied from telescope buffers picker
  local Path = require 'plenary.path'
  ---@return boolean
  local function buf_in_cwd(bufname, cwd)
    if cwd:sub(-1) ~= Path.path.sep then
      cwd = cwd .. Path.path.sep
    end
    local bufname_prefix = bufname:sub(1, #cwd)
    return bufname_prefix == cwd
  end

  local bufnrs = vim.tbl_filter(function(bufnr)
    if 1 ~= vim.fn.buflisted(bufnr) then
      return false
    end
    -- only hide unloaded buffers if opts.show_all_buffers is false, keep them listed if true or nil
    if not vim.api.nvim_buf_is_loaded(bufnr) then
      return false
    end
    if bufnr == vim.api.nvim_get_current_buf() then
      return false
    end

    local bufname = vim.api.nvim_buf_get_name(bufnr)

    if not buf_in_cwd(bufname, vim.loop.cwd()) then
      return false
    end
    return true
  end, vim.api.nvim_list_bufs())

  local buffers = {}
  for _, bufnr in ipairs(bufnrs) do
    local flag = bufnr == vim.fn.bufnr '' and '%' or (bufnr == vim.fn.bufnr '#' and '#' or ' ')

    local element = {
      bufnr = bufnr,
      flag = flag,
      info = vim.fn.getbufinfo(bufnr)[1],
    }

    if flag == '#' or flag == '%' then
      local idx = ((buffers[1] ~= nil and buffers[1].flag == '%') and 2 or 1)
      table.insert(buffers, idx, element)
    else
      table.insert(buffers, element)
    end
  end

  opts = vim.tbl_extend('force', {
    direction = 'forward',
    max_results = #setts.labels,
  }, opts or {})

  if setts.max_results then
    opts.max_results = math.min(opts.max_results, setts.max_results)
  end

    -- stylua: ignore
    local iter = iterator:new(buffers)
        :take(setts.lookback)

  if opts.start then
    iter = iter:start_at(opts.start)
  end
  if opts.direction == search.direction.backward then
    iter = iter:reverse()
  end

  iter = iter:map(function(v)
    return content:new {
      type = 'recent buffers',
      buffer = v.bufnr,
      cursor = { row = v.info.lnum, col = 1 },
      callback = function(con)
        vim.api.nvim_win_set_buf(0, con.buffer)
        vim.api.nvim_win_set_cursor(0, { con.cursor.row, con.cursor.col })
      end,
    }
  end)

  iter = iter:filter(function(v)
    return vim.api.nvim_buf_is_valid(v.buffer)
  end)
  if setts.filter then
    iter = iter:filter(setts.filter)
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
  return buffer_generator(opts or {}, settings)
end

return M
