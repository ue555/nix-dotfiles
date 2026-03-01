-- LspAttach autocommand でキーマップを設定
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local opts = { noremap = true, silent = true, buffer = args.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  end,
})

-- 全 LSP クライアントに ddc-source-lsp の capabilities を設定
vim.lsp.config("*", {
  capabilities = require("ddc_source_lsp").make_client_capabilities(),
})

vim.lsp.config("ts_ls", {})
vim.lsp.enable("ts_ls")

vim.lsp.config("gopls", {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.work", "go.mod", ".git" },
  capabilities = require("ddc_source_lsp").make_client_capabilities(),
})
vim.lsp.enable("gopls")

-- Terraform Language Server
local capabilities = require("ddc_source_lsp").make_client_capabilities()
vim.lsp.config("terraformls", {
  cmd = { "terraform-ls", "serve" },
  filetypes = { "terraform", "tf", "tfvars" },
  root_markers = { ".terraform", ".git" },
  capabilities = capabilities,
})
vim.lsp.enable("terraformls")

vim.lsp.config("efm", {
  init_options = { documentFormatting = true },
  filetypes = { "go", "lua", "typescript", "javascript", "typescriptreact", "javascriptreact", "terraform" },
  settings = {
    rootMarkers = { ".git/" },
    languages = {
      lua = {
        { formatCommand = "stylua -g '*.lua' -g '!*.spec.lua' -- .", formatStdin = true },
      },
      typescript = {
        { formatCommand = "prettier --stdin-filepath ${INPUT}", formatStdin = true },
      },
      javascript = {
        { formatCommand = "prettier --stdin-filepath ${INPUT}", formatStdin = true },
      },
      typescriptreact = {
        { formatCommand = "prettier --stdin-filepath ${INPUT}", formatStdin = true },
      },
      javascriptreact = {
        { formatCommand = "prettier --stdin-filepath ${INPUT}", formatStdin = true },
      },
      go = {
        { formatCommand = "gofmt", formatStdin = true },
        { lintCommand = "golangci-lint run --out-format line-number", lintStdin = false, lintFormats = { "%f:%l:%c: %m" } },
      },
      terraform = {
        { formatCommand = "terraform fmt -", formatStdin = true },
      },
    },
  },
})
vim.lsp.enable("efm")
