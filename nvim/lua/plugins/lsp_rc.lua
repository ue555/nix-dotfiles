local ddc = vim.fn

-- LSPのcapabilitiesを作成し、denolsに適用
local capabilities = require("ddc_source_lsp").make_client_capabilities()
vim.lsp.config("denols", {
  capabilities = capabilities,
})
vim.lsp.enable("denols")

-- ddc.vim の設定
ddc["ddc#custom#patch_global"]("sources", { "lsp" })
ddc["ddc#custom#patch_global"]("sourceOptions", {
  lsp = {
    mark = "lsp",
    forceCompletionPattern = "\\.\\w*|:\\w*|->\\w*",
  },
})

ddc["ddc#custom#patch_global"]("sourceParams", {
  lsp = {
    snippetEngine = vim.fn["denops#callback#register"](function(body)
      return vim.fn["vsnip#anonymous"](body)
    end),
    enableResolveItem = true,
    enableAdditionalTextEdit = true,
  },
})

-- ddcを有効化
ddc["ddc#enable"]()
