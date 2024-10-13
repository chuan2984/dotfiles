return {
  {
    '3rd/image.nvim',
    cond = function()
      return vim.fn.has 'win32' ~= 1
    end,
    ft = { 'markdown' },
    dependencies = { 'leafo/magick' },
    build = function()
      local function set_dyld_library_path()
        local function trim(s)
          return s:match '^%s*(.-)%s*$'
        end

        local brew_prefix = trim(vim.fn.system 'brew --prefix')
        local dyld_path = trim(os.getenv 'DYLD_LIBRARY_PATH' or '')
        local new_path = brew_prefix .. '/lib' .. dyld_path
        -- Check if the path is already set
        if not string.find(dyld_path, brew_prefix .. '/lib', 1, true) then
          local update_command = string.format(
            'echo \'export DYLD_LIBRARY_PATH="%s:$DYLD_LIBRARY_PATH"\' >> ~/.zshrc',
            brew_prefix .. '/lib'
          )
          local success = os.execute(update_command)

          if success then
            print 'Updated ~/.zshrc with new DYLD_LIBRARY_PATH'
            -- Set for current session
            os.execute('export DYLD_LIBRARY_PATH="' .. new_path .. '"')
          else
            print 'Failed to update ~/.zshrc'
          end
        end
      end
      local imagemagick_installed = vim.fn.system 'command -v convert' ~= ''
      if not imagemagick_installed then
        print 'ImageMagick not found. Installing via brew...'
        vim.schedule(function()
          os.execute 'brew install imagemagick'
          set_dyld_library_path()
        end)
      else
        print 'ImageMagick already installed, examining path...'
        set_dyld_library_path()
      end
    end,
    opts = {
      backend = 'kitty',
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = true,
          download_remote_images = true,
          only_render_image_at_cursor = true,
          filetypes = { 'markdown', 'vimwiki' }, -- markdown extensions (ie. quarto) can go here
        },
        neorg = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { 'norg' },
        },
      },
      max_width = nil,
      max_height = nil,
      max_width_window_percentage = nil,
      max_height_window_percentage = 50,
      kitty_method = 'normal',
    },
  },
}
