return {
  -- NOTE: This handles all formatting and not `null-ls`
  -- as this has way better support for finer control and has autosave as a simple option
  -- It would use formatters_by_ft as the default for the formatter of each language
  -- and if not specified, it would fallback to the LSP, which may or may not have a formatting
  -- capability.
  'stevearc/conform.nvim',
  event = 'BufWritePre',
  opts = {
    notify_on_error = false,
    format_on_save = {
      timeout_ms = 3500,
      lsp_fallback = true,
    },
    formatters_by_ft = {
      lua = { 'stylua' },
      markdown = { 'markdownlint' },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
