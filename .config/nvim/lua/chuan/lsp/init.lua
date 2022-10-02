local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  print('not able to load lspconfig')
  return
end

require("chuan.lsp.lsp-installer")
require("chuan.lsp.handlers").setup()
