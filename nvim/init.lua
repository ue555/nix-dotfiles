local dpp_src = "$HOME/.cache/dpp/repos/github.com/Shougo/dpp.vim"

local dpp_base = vim.fn.expand("$HOME/.cache/dpp/nvim")
local dpp_config = "~/.config/nvim/dpp.ts"
local dpp_cache = vim.fn.expand("$HOME/.cache/dpp/nvim/.dpp")

local denops_src = "$HOME/.cache/dpp/repos/github.com/vim-denops/denops.vim"

local ext_toml = "$HOME/.cache/dpp/repos/github.com/Shougo/dpp-ext-toml"
local ext_lazy = "$HOME/.cache/dpp/repos/github.com/Shougo/dpp-ext-lazy"
local ext_installer = "$HOME/.cache/dpp/repos/github.com/Shougo/dpp-ext-installer"
local ext_git = "$HOME/.cache/dpp/repos/github.com/Shougo/dpp-protocol-git"

-- dppキャッシュとリポジトリのluaモジュールをpackage.pathに追加
local dpp_repos = vim.fn.expand("$HOME/.cache/dpp/repos/github.com")
package.path = dpp_cache .. "/lua/?.lua;" .. dpp_cache .. "/lua/?/init.lua;" .. package.path

-- リポジトリ内のluaモジュールを検索できるようにする（シンボリックリンク対策）
for _, repo in ipairs(vim.fn.globpath(dpp_repos, "*/*/lua", true, true)) do
  package.path = repo .. "/?.lua;" .. repo .. "/?/init.lua;" .. package.path
end

vim.opt.runtimepath:prepend(dpp_cache)
vim.opt.runtimepath:prepend(dpp_src)
vim.opt.runtimepath:append(ext_toml)
vim.opt.runtimepath:append(ext_git)
vim.opt.runtimepath:append(ext_lazy)
vim.opt.runtimepath:append(ext_installer)

if vim.fn["dpp#min#load_state"](dpp_base) then
  vim.opt.runtimepath:prepend(denops_src)

  vim.api.nvim_create_augroup("ddp", {})

  vim.cmd(string.format("autocmd User DenopsReady call dpp#make_state('%s', '%s')", dpp_base, dpp_config))
end

vim.cmd("filetype indent plugin on")

if vim.fn.has("syntax") then
  vim.cmd("syntax on")
end

-- 初期の設定、以下参考元
-- [Neovimでdpp.vimをセットアップする]
-- https://zenn.dev/comamoca/articles/howto-setup-dpp-vim
--
--local dpp_src = "$HOME/.cache/dpp/repos/github.com/Shougo/dpp.vim"
---- プラグイン内のLuaモジュールを読み込むため、先にruntimepathに追加する必要があります。
--vim.opt.runtimepath:prepend(dpp_src)
--local dpp = require("dpp")
--
--local dpp_base = "~/.cache/dpp/"
--local dpp_config = "~/.config/nvim/dpp.ts"
--
--local denops_src = "$HOME/.cache/dpp/repos/github.com/vim-denops/denops.vim"
--
--local ext_toml = "$HOME/.cache/dpp/repos/github.com/Shougo/dpp-ext-toml"
--local ext_lazy = "$HOME/.cache/dpp/repos/github.com/Shougo/dpp-ext-lazy"
--local ext_installer = "$HOME/.cache/dpp/repos/github.com/Shougo/dpp-ext-installer"
--local ext_git = "$HOME/.cache/dpp/repos/github.com/Shougo/dpp-protocol-git"
--
--vim.opt.runtimepath:append(ext_toml)
--vim.opt.runtimepath:append(ext_git)
--vim.opt.runtimepath:append(ext_lazy)
--vim.opt.runtimepath:append(ext_installer)
--
---- denops shared serverの設定
---- vim.g.denops_server_addr = "127.0.0.1:34141"
--
---- denopsのデバッグフラグ
---- denopsプラグインの開発をしない場合は0(デフォルト)にしてください
---- vim.g["denops#debug"] = 1
--
--if dpp.load_state(dpp_base) then
--  vim.opt.runtimepath:prepend(denops_src)
--
--  vim.api.nvim_create_autocmd("User", {
--	  pattern = "DenopsReady",
--  	callback = function ()
--		vim.notify("vim load_state is failed")
--  		dpp.make_state(dpp_base, dpp_config)
--  	end
--  })
--end
--
---- これはなくても大丈夫です。
--vim.api.nvim_create_autocmd("User", {
--	pattern = "Dpp:makeStatePost",
--	callback = function ()
--		vim.notify("dpp make_state() is done")
--	end
--})

require("keymaps")
require("settings")
-- 以下のrequireはプラグインロード後に実行される必要があります
-- TOMLファイルのlua_sourceで設定します
-- require("ddc")
-- require("tool")
-- require("scripts.historylist")
-- require("scripts.auto-pairs")
