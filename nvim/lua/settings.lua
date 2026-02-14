-- donops のプラグインの共有サーバーの設定
--vim.g.denops_server_addr = "127.0.0.1:32123"

-- クリップボードの設定
vim.opt.clipboard:append("unnamedplus")

vim.opt.number = true

local current_listchars = vim.opt.listchars:get()
current_listchars.space = "."
vim.opt.listchars = current_listchars
vim.opt.list = true
