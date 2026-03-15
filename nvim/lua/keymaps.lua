-- usually
vim.api.nvim_set_keymap("n", "q", "<cmd>q<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "qa", "<cmd>qa<CR>", { noremap = true, silent = true })

vim.o.clipboard = "unnamedplus"

-- nvim-tree
vim.keymap.set("n", "]e", ":NvimTreeOpen<CR>")
-- 行番号を表示する設定
vim.opt.number = true
-- 現在の listchars（不可視文字の表示設定）を取得(タブやスペースなどの不可視文字をどのように表示するかを設定するオプション)
local current_listchars = vim.opt.listchars:get()
-- スペースを .（ドット）で表示する設定(listchars の space の値を "." に変更する)
current_listchars.space = "."
-- 変更した listchars を再設定(current_listchars に追加した space = "." を反映させる)
vim.opt.listchars = current_listchars
-- 不可視文字を表示する(set list（VimScript の set list と同じ意味）)
vim.opt.list = true

-- telescope.nvim
vim.keymap.set("n", "]ff", ":Telescope find_files<CR>")
vim.keymap.set("n", "]fg", ":Telescope live_grep<CR>")
vim.keymap.set("n", "]fb", ":Telescope buffers<CR>")
vim.keymap.set("n", "]fh", ":Telescope help_tags<CR>")

vim.api.nvim_create_user_command("DppUpdate", function()
  vim.cmd("call dpp#async_ext_action('installer', 'update')")
end, { desc = "update dpp.nvim plugins" })

vim.api.nvim_create_user_command("DppInstall", function()
  vim.cmd("call dpp#async_ext_action('installer', 'install')")
end, { desc = "install dpp.nvim plugins" })

vim.api.nvim_create_user_command("Format", function()
  vim.lsp.buf.format()
end, {})

-- Auto format on save for specific filetypes
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.lua", "*.go", "*.ts", "*.js", "*.tsx", "*.jsx", "*.tf", "*.tfvars" },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- 診断エラーの詳細をフローティングウィンドウで表示
vim.keymap.set("n", "[e", function()
  vim.diagnostic.open_float(nil, { scope = "line" })
end, { desc = "Show diagnostic detail" })

-- Go ドキュメントをターミナルで表示
vim.keymap.set("n", "]gd", function()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1

  -- カーソル位置から pkg.Symbol or symbol を抽出
  local s, e = col, col
  while s > 1 and line:sub(s-1, s-1):match("[%w_]") do s = s - 1 end
  if s > 1 and line:sub(s-1, s-1) == "." then
    s = s - 1
    while s > 1 and line:sub(s-1, s-1):match("[%w_]") do s = s - 1 end
  end
  while e <= #line and line:sub(e, e):match("[%w_]") do e = e + 1 end
  if e <= #line and line:sub(e, e) == "." then
    e = e + 1
    while e <= #line and line:sub(e, e):match("[%w_]") do e = e + 1 end
  end
  local word = line:sub(s, e - 1)

  local builtins = {
    make=true, len=true, cap=true, append=true, copy=true, delete=true,
    new=true, panic=true, recover=true, print=true, println=true, close=true,
    complex=true, real=true, imag=true, clear=true, max=true, min=true,
  }
  local target = builtins[word] and ("builtin." .. word) or word
  local dir = vim.fn.expand("%:p:h")
  local cmd = string.format("cd %s && go doc %s", vim.fn.shellescape(dir), vim.fn.shellescape(target))
  vim.cmd("split | terminal " .. cmd)
end, { desc = "Go doc for word under cursor" })
