-- load mason to handle LSP related tasks
local status_ok, mason = pcall(require, "mason")
if not status_ok then
  print('unable to load mason')
	return
end
mason.setup()

-- setups all LSP related configurations
require("chuan.lsp.lsp-configuration")

