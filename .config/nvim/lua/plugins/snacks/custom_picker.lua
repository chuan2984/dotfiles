local M = {}

local git_grep_hunks = {
  supports_live = false,
  format = function(item, picker)
    local file_format = Snacks.picker.format.file(item, picker)
    vim.api.nvim_set_hl(0, 'SnacksPickerGitGrepLineNew', { link = 'Added' })
    vim.api.nvim_set_hl(0, 'SnacksPickerGitGrepLineOld', { link = 'Removed' })
    if item.sign == '+' then
      file_format[#file_format - 1][2] = 'SnacksPickerGitGrepLineNew'
    else
      file_format[#file_format - 1][2] = 'SnacksPickerGitGrepLineOld'
    end
    return file_format
  end,
  finder = function(f_opts, ctx)
    local hcount = 0
    local header = {
      file = '',
      old = { start = 0, count = 0 },
      new = { start = 0, count = 0 },
    }
    local sign_count = 0
    return require('snacks.picker.source.proc').proc(
      vim.tbl_deep_extend('force', {
        cmd = 'git',
        args = { 'diff', '--unified=0' },
        transform = function(item) ---@param item snacks.picker.finder.Item
          local line = item.text
          -- [[Header]]
          if line:match '^diff' then
            hcount = 3
          elseif hcount > 0 then
            if hcount == 1 then
              header.file = line:sub(7)
            end
            hcount = hcount - 1
          elseif line:match '^@@' then
            local parts = vim.split(line:match '@@ ([^@]+) @@', ' ')
            local old_start, old_count = parts[1]:match '-(%d+),?(%d*)'
            local new_start, new_count = parts[2]:match '+(%d+),?(%d*)'
            header.old.start, header.old.count = tonumber(old_start), tonumber(old_count) or 1
            header.new.start, header.new.count = tonumber(new_start), tonumber(new_count) or 1
            sign_count = 0
          -- [[Body]]
          elseif not line:match '^[+-]' then
            sign_count = 0
          elseif line:match '^[+-]%s*$' then
            sign_count = sign_count + 1
          else
            item.sign = line:sub(1, 1)
            item.file = header.file
            item.line = line:sub(2)
            if item.sign == '+' then
              item.pos = { header.new.start + sign_count, 0 }
              sign_count = sign_count + 1
            else
              item.pos = { header.new.start, 0 }
              sign_count = 0
            end
            return true
          end
          return false
        end,
      }, f_opts or {}),
      ctx
    )
  end,
}

local ast_grep = {
  format = 'file',
  notify = false, -- Also prevents error when searching with additional arguments
  show_empty = true,
  live = true,
  supports_live = true,
  -- hidden = true,
  -- ignored = true,
  ---@param opts snacks.picker.grep.Config
  finder = function(opts, ctx)
    local cmd = 'ast-grep'
    local args = { 'run', '--color=never', '--json=stream' }
    if vim.fn.has 'win32' == 1 then
      cmd = 'sg'
    end
    if opts.hidden then
      table.insert(args, '--no-ignore=hidden')
    end
    if opts.ignored then
      table.insert(args, '--no-ignore=vcs')
    end
    local pattern, pargs = Snacks.picker.util.parse(ctx.filter.search)
    table.insert(args, string.format('--pattern=%s', pattern))
    vim.list_extend(args, pargs)
    return require('snacks.picker.source.proc').proc(
      vim.tbl_deep_extend('force', {
        cmd = cmd,
        args = args,
        transform = function(item)
          local entry = vim.json.decode(item.text)
          if vim.tbl_isempty(entry) then
            return false
          else
            local start = entry.range.start
            item.cwd = svim.fs.normalize(opts and opts.cwd or vim.uv.cwd() or '.') or nil
            item.file = entry.file
            item.line = entry.text
            item.pos = { tonumber(start.line) + 1, tonumber(start.column) }
          end
        end,
      }, opts or {}),
      ctx
    )
  end,
}

M.git_grep_hunks = git_grep_hunks
M.ast_grep = ast_grep

return M
