return {
  'nvimtools/none-ls.nvim',
  event = 'VeryLazy',
  config = function()
    local null_ls = require 'null-ls'
    local helpers = require 'null-ls.helpers'

    local detekt = {
      method = null_ls.methods.DIAGNOSTICS,
      filetypes = { 'kotlin' },
      generator = null_ls.generator {
        command = 'detekt',
        debounce = 200,
        args = {
          '--input',
          '$FILENAME',
          '--config',
          'detekt/config.yml',
          '--build-upon-default-config',
        },
        to_stdin = false,
        from_stderr = true,
        format = 'raw', -- Changed from "line" to "raw"
        check_exit_code = function(code, _)
          return code <= 1
        end,
        on_output = function(params, done)
          local output = params.output
          if not output then
            return done()
          end

          local diagnostics = {}

          -- Split output into lines and process each
          for line in output:gmatch '[^\r\n]+' do
            -- Pattern: /path/file.kt:24:9: message [RuleName]
            local row, col, message, code = line:match '^.+%.kt:(%d+):(%d+): (.+) %[(.+)%]$'

            if row and col and message and code then
              table.insert(diagnostics, {
                row = tonumber(row),
                col = tonumber(col),
                message = message,
                severity = helpers.diagnostics.severities.warning,
                code = code,
              })
            end
          end

          done(diagnostics)
        end,
      },
    }

    null_ls.register(detekt)

    local home = os.getenv 'HOME'
    local excluded_gp_path = home .. '/.local/share/nvim/gp/chats'
    local markdownlint_config = home .. '/dotfiles/lsp_setting/.markdownlint.yaml'
    null_ls.setup {
      -- NOTE: only using none-ls for parsing otherwise non-compatible diagnostics
      -- which usually comes from a cli or has no existing LSP
      -- formatting is done through conform, which saves me the trouble of having to
      -- write a sophicated AutoCmd for using which formatter on save
      sources = {
        null_ls.builtins.diagnostics.markdownlint.with {
          extra_args = { '--config', markdownlint_config },
          runtime_condition = helpers.cache.by_bufnr(function(params)
            return params.bufname:find(excluded_gp_path, 1, true) == nil
          end),
        },
      },
    }
  end,
}
