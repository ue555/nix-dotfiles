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
