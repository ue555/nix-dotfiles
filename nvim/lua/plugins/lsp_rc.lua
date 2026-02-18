local ddc = vim.fn

-- LSPのcapabilitiesを作成
local capabilities = require("ddc_source_lsp").make_client_capabilities()

-- denolsに適用
vim.lsp.config("denols", {
  capabilities = capabilities,
})
vim.lsp.enable("denols")

