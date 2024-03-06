-- using mason-lspconfig as a middleman to access lspconfig,
-- and handles all lsp installation related tasks
local status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_ok then
  print('not able to load mason-lspconfig')
  return
end

mason_lspconfig.setup({
  ensure_installed = { "lua_ls" }
})

-- an handler module for adjusting nvim settings
local handler = require("chuan.lsp.handlers")

local get_options_based_on_server = function (server_name)
  local options = {
    on_attach = handler.on_attach,
    capabilities = handler.capabilities,
  }

  if server_name == "jsonls" then
    local jsonls_opts = require("chuan.lsp.settings.jsonls")
    options = vim.tbl_deep_extend("force", jsonls_opts, options)
  end

  if server_name == "lua_ls" then
    local sumneko_opts = require("chuan.lsp.settings.lua_ls")
    options = vim.tbl_deep_extend("force", sumneko_opts, options)
  end

  if server_name == "solargraph" then
    local solargraph_opts = require("chuan.lsp.settings.solargraph")
    options = vim.tbl_deep_extend("force", solargraph_opts, options)
  end

  return options
end

mason_lspconfig.setup_handlers({
  function (server_name)
    local opts = get_options_based_on_server(server_name)
    require("lspconfig")[server_name].setup(opts)
  end,
})

handler.setup()
