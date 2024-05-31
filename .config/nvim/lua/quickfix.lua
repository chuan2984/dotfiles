-- NOTE: This only works with a list of paths
-- Can be improved by providing some other options like colum and line number
-- but i dont see a use case for those yet
function Populate_qflist_from_file(path)
  local file = io.open(path, 'r')
  if not file then
    print('Failed to open file: ' .. path)
    return
  end

  local qflist = {}
  for line in file:lines() do
    if line ~= '' then
      table.insert(qflist, { filename = line, lnum = 1, col = 1 })
    end
  end
  file:close()

  vim.fn.setqflist(qflist, 'r')

  print('Quickfix list populated with ' .. #qflist .. ' entries from ' .. path)

  vim.cmd 'copen'
end

vim.cmd 'command! -nargs=1 PopulateQfListFromFile lua Populate_qflist_from_file(<f-args>)'

function Save_qf_list(filename, bang)
  filename = filename == '' and 'qflist.vim' or filename

  -- Save window view
  local _w = vim.fn.winsaveview()

  -- Get qflist and its title
  local _qflist = vim.fn.getqflist()
  local _qfinfo = vim.fn.getqflist { title = 1 }
  local _qfopen = not vim.tbl_isempty(vim.tbl_filter(function(v)
    return vim.fn.getbufvar(v, '&buftype') == 'quickfix'
  end, vim.fn.tabpagebuflist()))

  -- Set all buffers listed in qflist as buflisted
  for _, entry in ipairs(_qflist) do
    vim.fn.setbufvar(entry.bufnr, '&buflisted', 1)
  end

  -- Close qflist window
  vim.cmd 'cclose'

  -- Save a session file if needed
  -- vim.cmd(string.format('mksession %s %s', bang == 1 and '!' or '', filename))

  -- Open the qflist window again
  if _qfopen then
    vim.cmd 'cwindow'
    vim.cmd 'wincmd p'
  end

  -- Save the qflist
  local _setqflist = string.format('call setqflist(%s)', vim.fn.string(_qflist))
  local _setqfinfo = string.format('call setqflist([], "a", %s)', vim.fn.string(_qfinfo))
  vim.fn.writefile({ _setqflist, _setqfinfo }, filename, 'a')
  if _qfopen then
    vim.fn.writefile({ 'cwindow', 'wincmd p' }, filename, 'a')
  end

  -- Restore window view
  vim.fn.winrestview(_w)
end

vim.cmd 'command! -nargs=? -bang SaveQfList lua Save_qf_list(<q-args>, <bang>0)'

function Load_qf_list(filename)
  filename = filename == '' and 'qflist.vim' or filename
  vim.cmd(string.format('source %s', filename))
end

vim.cmd 'command! -nargs=? LoadQfList lua Load_qf_list(<q-args>)'
-- vim: ts=2 sts=2 sw=2 et
