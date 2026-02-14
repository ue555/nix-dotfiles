-- Register linters and formatters per language
local prettier = require("efmls-configs.formatters.prettier")
local stylua = require("efmls-configs.formatters.stylua")
local jq = require("efmls-configs.formatters.jq")
local yq = require("efmls-configs.formatters.yq")
local gofmt = require("efmls-configs.formatters.gofmt")
--local ktlint = {
--  formatCommand = "ktlint --format",
--  formatStdin = true,
--  rootMarkers = { ".git" },
--}
local languages = {
  typescript = { prettier },
  lua = { stylua },
  json = { jq },
  yaml = { yq },
  go = { gofmt },
}

-- Or use the defaults provided by this plugin
-- check doc/SUPPORTED_LIST.md for the supported languages
--
-- local languages = require('efmls-configs.defaults').languages()

local efmls_config = {
  filetypes = vim.tbl_keys(languages),
  settings = {
    rootMarkers = { ".git/" },
    languages = languages,
  },
  init_options = {
    documentFormatting = true,
    documentRangeFormatting = true,
  },
}

vim.lsp.config("efm", vim.tbl_extend("force", efmls_config, {
  -- Pass your custom lsp config below like on_attach and capabilities
  --
  -- on_attach = on_attach,
  -- capabilities = capabilities,
}))
vim.lsp.enable("efm")

local lsp_fmt_group = vim.api.nvim_create_augroup("LspFormattingGroup", {})
vim.api.nvim_create_autocmd("BufWritePost", {
  group = lsp_fmt_group,
  callback = function(ev)
    local efm = vim.lsp.get_clients({ name = "efm", bufnr = ev.buf })

    if vim.tbl_isempty(efm) then
      return
    end

    vim.lsp.buf.format({ name = "efm" })
  end,
})
