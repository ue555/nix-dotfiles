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

vim.lsp.config("ts_ls", {})
vim.lsp.enable("ts_ls")

vim.lsp.config("gopls", {})
vim.lsp.enable("gopls")

vim.lsp.config("efm", {
  init_options = { documentFormatting = true },
  filetypes = { "go", "lua", "typescript", "javascript", "typescriptreact", "javascriptreact" },
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
      },
    },
  },
})
vim.lsp.enable("efm")
