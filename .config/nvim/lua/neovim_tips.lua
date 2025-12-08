local M = {}

--[[
Neovim Tips Plugin

Commands:
  :NeovimTips       - Open live search picker
  :NeovimTipsRandom - Show random tip in floating window
  :NeovimTipsReload - Reload tips from markdown files (clears cache)

Search:
  #tagname - Filter by exact tag (e.g., #java, #lsp)
  text     - Filter by substring match in title/category

Tip History:
  - Tips are tracked to avoid repetition
  - No tip shown more than once per month
  - No tip shown more than twice in 3 months
  - History stored in: ~/.local/share/nvim/neovim-tips-daily.json
--]]

local _tips_cache = nil

local config = {
  data_dir = os.getenv('HOME') .. '/github/neovim-tips/data',
  daily_tip = true,
  persistent_file = vim.fn.stdpath 'data' .. '/neovim-tips-daily.json',
}

local function parse_markdown_file(file_path)
  local tips = {}
  local file = io.open(file_path, 'r')
  if not file then
    return tips
  end

  local content = file:read '*a'
  file:close()

  content = content .. '\n***\n'

  for tip_block in content:gmatch '(.-)\n[*=][*=][*=]\n' do
    local tip = {}

    local title = tip_block:match '# Title:%s*([^\n]+)'
    if title then
      tip.title = vim.trim(title)
    end

    local category = tip_block:match '# Category:%s*([^\n]+)'
    if category then
      tip.category = vim.trim(category)
    end

    local tags_line = tip_block:match '# Tags:%s*([^\n]+)'
    if tags_line then
      tip.tags = {}
      for tag in tags_line:gmatch '[^,]+' do
        table.insert(tip.tags, vim.trim(tag))
      end
    end

    local description = tip_block:match '---\n(.+)$'
    if description then
      tip.description = vim.trim(description)
    end

    if tip.title and tip.title ~= '' then
      table.insert(tips, tip)
    end
  end

  return tips
end

local function load_tips()
  if _tips_cache then
    return _tips_cache
  end

  local all_tips = {}
  local data_dir = config.data_dir

  if vim.fn.isdirectory(data_dir) == 0 then
    vim.notify('Neovim tips data directory not found: ' .. data_dir, vim.log.levels.WARN)
    return all_tips
  end

  local files = vim.fn.glob(data_dir .. '/*.md', false, true)
  for _, file in ipairs(files) do
    local tips = parse_markdown_file(file)
    vim.list_extend(all_tips, tips)
  end

  _tips_cache = all_tips
  return all_tips
end

local function format_tip_item(tip)
  if not tip.title or tip.title == '' then
    return nil
  end

  local category_tag = tip.category and ('[' .. tip.category .. ']') or ''

  return {
    title = tip.title,
    category = tip.category,
    tags = tip.tags,
    description = tip.description,
    text = string.format('%s %s', category_tag, tip.title),
    category_tag = category_tag,
  }
end

-- Create picker source
local function create_tips_source()
  return {
    name = 'neovim_tips',
    supports_live = true,
    live = false,
    format = function(item, picker)
      local ret = {} ---@type snacks.picker.Highlight[]

      if item.category_tag and item.category_tag ~= '' then
        ret[#ret + 1] = { item.category_tag, 'Special' }
        ret[#ret + 1] = { ' ' }
      end

      ret[#ret + 1] = { item.title }
      return ret
    end,
    finder = function(opts, ctx)
      local tips = load_tips()
      local items = {}

      local search = ctx.filter and ctx.filter.search or ''
      local is_tag_search = search:match '^#'
      local tag_search = is_tag_search and search:sub(2):lower() or nil

      for _, tip in ipairs(tips) do
        local item = format_tip_item(tip)
        if item then
          if is_tag_search then
            local has_tag = false
            if item.tags then
              for _, tag in ipairs(item.tags) do
                if tag:lower() == tag_search then
                  has_tag = true
                  break
                end
              end
            end
            if has_tag then
              table.insert(items, item)
            end
          elseif search == '' then
            table.insert(items, item)
          else
            local search_lower = search:lower()
            if item.text:lower():find(search_lower, 1, true) then
              table.insert(items, item)
            end
          end
        end
      end
      return items
    end,
    preview = function(ctx)
      ctx.preview:reset()

      local item = ctx.item
      if not item or not item.title then
        ctx.preview:notify('No item or title found', 'error')
        return
      end

      local lines = {}
      table.insert(lines, '# ' .. item.title)
      table.insert(lines, '')

      if item.category then
        table.insert(lines, '**Category:** ' .. item.category)
        table.insert(lines, '')
      end

      if item.tags and #item.tags > 0 then
        table.insert(lines, '**Tags:** ' .. table.concat(item.tags, ', '))
        table.insert(lines, '')
      end

      if item.description then
        table.insert(lines, '---')
        table.insert(lines, '')
        for line in item.description:gmatch '[^\r\n]+' do
          table.insert(lines, line)
        end
      end

      ctx.preview:set_title(item.title)
      ctx.preview:set_lines(lines)
      ctx.preview:highlight { ft = 'markdown' }
    end,
  }
end

function M.show_tips()
  local tips = load_tips()
  if #tips == 0 then
    vim.notify('No tips found', vim.log.levels.INFO)
    return
  end

  local Snacks = require 'snacks'

  local function show_tip_window(picker, item)
    if not item then
      return
    end

    local item_data = {
      title = item.title,
      category = item.category,
      tags = item.tags,
      description = item.description,
    }

    picker:close()

    vim.schedule(function()
      local lines = {}
      table.insert(lines, '# ' .. item_data.title)
      table.insert(lines, '')

      if item_data.category then
        table.insert(lines, '**Category:** ' .. item_data.category)
        table.insert(lines, '')
      end

      if item_data.tags and #item_data.tags > 0 then
        table.insert(lines, '**Tags:** ' .. table.concat(item_data.tags, ', '))
        table.insert(lines, '')
      end

      table.insert(lines, '---')
      table.insert(lines, '')

      if item_data.description then
        for line in item_data.description:gmatch '[^\r\n]+' do
          table.insert(lines, line)
        end
      end

      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      vim.bo[buf].filetype = 'markdown'
      vim.bo[buf].modifiable = false

      local width = math.floor(vim.o.columns * 0.6)
      local height = math.floor(vim.o.lines * 0.6)
      local col = math.floor((vim.o.columns - width) / 2)
      local row = math.floor((vim.o.lines - height) / 2)

      local win = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = width,
        height = height,
        col = col,
        row = row,
        style = 'minimal',
        border = 'rounded',
        title = ' Neovim Tip ',
        title_pos = 'center',
      })

      vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = buf, nowait = true })
      vim.keymap.set('n', '<Esc>', '<cmd>close<cr>', { buffer = buf, nowait = true })
    end)
  end

  Snacks.picker.pick('neovim_tips', {
    actions = {
      confirm = function(picker)
        local item = picker:current()
        show_tip_window(picker, item)
      end,
    },
  })
end

local function load_tip_history()
  local persistent_file = config.persistent_file
  local file = io.open(persistent_file, 'r')
  if not file then
    return { last_shown = nil, history = {} }
  end

  local data = file:read '*a'
  file:close()
  local ok, decoded = pcall(vim.json.decode, data)
  if ok and decoded then
    decoded.history = decoded.history or {}
    return decoded
  end
  return { last_shown = nil, history = {} }
end

local function save_tip_history(history_data)
  local persistent_file = config.persistent_file
  local dir = vim.fn.fnamemodify(persistent_file, ':h')
  vim.fn.mkdir(dir, 'p')

  local file = io.open(persistent_file, 'w')
  if file then
    file:write(vim.json.encode(history_data))
    file:close()
  end
end

local function days_since(date_str)
  if not date_str then
    return math.huge
  end
  local year, month, day = date_str:match '(%d+)-(%d+)-(%d+)'
  if not year then
    return math.huge
  end
  local past = os.time { year = year, month = month, day = day }
  local now = os.time()
  return math.floor((now - past) / 86400)
end

local function get_eligible_tips()
  local all_tips = load_tips()
  local history_data = load_tip_history()
  local eligible = {}

  for _, tip in ipairs(all_tips) do
    local tip_key = tip.title
    local tip_history = history_data.history[tip_key] or {}
    local can_show = true

    for _, shown_date in ipairs(tip_history) do
      local days = days_since(shown_date)
      if days < 30 then
        can_show = false
        break
      end
    end

    if can_show and #tip_history >= 2 then
      local recent_shows = 0
      for _, shown_date in ipairs(tip_history) do
        if days_since(shown_date) < 90 then
          recent_shows = recent_shows + 1
        end
      end
      if recent_shows >= 2 then
        can_show = false
      end
    end

    if can_show then
      table.insert(eligible, tip)
    end
  end

  return eligible
end

local function record_tip_shown(tip)
  local history_data = load_tip_history()
  local tip_key = tip.title
  local today = os.date '%Y-%m-%d'

  history_data.history[tip_key] = history_data.history[tip_key] or {}
  table.insert(history_data.history[tip_key], today)

  local cutoff_date = os.time() - (90 * 86400)
  for key, dates in pairs(history_data.history) do
    local filtered = {}
    for _, date_str in ipairs(dates) do
      local year, month, day = date_str:match '(%d+)-(%d+)-(%d+)'
      if year then
        local date_time = os.time { year = year, month = month, day = day }
        if date_time >= cutoff_date then
          table.insert(filtered, date_str)
        end
      end
    end
    history_data.history[key] = filtered
  end

  save_tip_history(history_data)
end

function M.show_random_tip(track_history)
  if track_history == nil then
    track_history = true
  end

  local tips = track_history and get_eligible_tips() or load_tips()
  if #tips == 0 then
    vim.notify('No eligible tips available', vim.log.levels.WARN)
    return
  end

  math.randomseed(os.time())
  local random_tip = tips[math.random(#tips)]

  if track_history then
    record_tip_shown(random_tip)
    local history_data = load_tip_history()
    history_data.last_shown = os.date '%Y-%m-%d'
    save_tip_history(history_data)
  end

  local lines = {}
  table.insert(lines, '# ' .. random_tip.title)
  table.insert(lines, '')

  if random_tip.category then
    table.insert(lines, '**Category:** ' .. random_tip.category)
    table.insert(lines, '')
  end

  if random_tip.tags and #random_tip.tags > 0 then
    table.insert(lines, '**Tags:** ' .. table.concat(random_tip.tags, ', '))
    table.insert(lines, '')
  end

  table.insert(lines, '---')
  table.insert(lines, '')

  if random_tip.description then
    for line in random_tip.description:gmatch '[^\r\n]+' do
      table.insert(lines, line)
    end
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].filetype = 'markdown'
  vim.bo[buf].modifiable = false

  local width = math.floor(vim.o.columns * 0.6)
  local height = math.floor(vim.o.lines * 0.6)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    style = 'minimal',
    border = 'rounded',
    title = ' Neovim Tip ',
    title_pos = 'center',
  })

  vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = buf, nowait = true })
  vim.keymap.set('n', '<Esc>', '<cmd>close<cr>', { buffer = buf, nowait = true })
end

local function should_show_daily_tip()
  local history_data = load_tip_history()
  local today = os.date '%Y-%m-%d'

  if history_data.last_shown == today then
    return false
  end

  return true
end

local function show_daily_tip()
  if not config.daily_tip then
    return
  end

  if not should_show_daily_tip() then
    return
  end

  vim.defer_fn(function()
    M.show_random_tip()
  end, 100)
end

function M.setup(opts)
  config = vim.tbl_deep_extend('force', config, opts or {})

  vim.api.nvim_create_user_command('NeovimTips', M.show_tips, { desc = 'Show Neovim tips picker' })
  vim.api.nvim_create_user_command('NeovimTipsRandom', M.show_random_tip, { desc = 'Show random Neovim tip' })
  vim.api.nvim_create_user_command('NeovimTipsReload', function()
    _tips_cache = nil
    package.loaded['neovim-tips'] = nil
    require 'neovim-tips'
    vim.notify('Neovim tips plugin reloaded', vim.log.levels.INFO)
  end, { desc = 'Reload Neovim tips plugin' })

  if config.daily_tip then
    vim.api.nvim_create_autocmd('VimEnter', {
      callback = show_daily_tip,
      once = true,
    })
  end
end

local function register_picker_source()
  local ok, Snacks = pcall(require, 'snacks')
  if ok and Snacks.picker then
    Snacks.picker.sources = Snacks.picker.sources or {}
    Snacks.picker.sources.neovim_tips = create_tips_source()
  end
end

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = register_picker_source,
  once = true,
})

vim.defer_fn(function()
  load_tips()
end, 500)

return M
