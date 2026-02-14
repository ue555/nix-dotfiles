# Neovim設定 with dpp.vim

dpp.vimを使用したNeovimの設定セットアップガイド

## 動作環境

- **Neovim**: 0.10.0以上
- **Deno**: denops.vim用（必須）
- **Go**: gopls（Go言語補完用）
- **efm-langserver**: TypeScript/Lua等のフォーマット用（オプション）

## 特徴

このNeovim設定は以下の機能を提供します：

- **dpp.vim**: 高速なプラグインマネージャー（遅延ロード対応）
- **ddc.vim**: LSPベースの自動補完（denops製）
- **nvim-lsp**: LSPクライアント（gopls, efm-langserver対応）
- **保存時自動フォーマット**: Go, TypeScript, Luaファイル対応
- **nvim-tree**: ファイルツリー
- **Lua設定**: Neovim nativeの高速設定

## セットアップ手順

### 1. 必要なツールのインストール

```bash
# Deno (denops.vim用)
curl -fsSL https://deno.land/install.sh | sh

# gopls (Go言語LSP)
go install golang.org/x/tools/gopls@latest

# efm-langserver (オプション)
go install github.com/mattn/efm-langserver@latest
```

### 2. dpp.vimのインストール

リポジトリのルートにある`dpp_setup.sh`を実行します：

```bash
cd ~/dotfiles
bash dpp_setup.sh
```

このスクリプトは以下を実行します：
- `~/.cache/dpp/repos/`にdpp.vimと必要な拡張機能をclone
- denops.vimをclone
- `~/.config/nvim`へのシンボリックリンク作成

### 3. Neovimの起動と初期化

初回起動時にプラグインの状態を生成します：

```bash
nvim
```

Neovim内で以下のコマンドを実行（初回のみ）：

```vim
:call dpp#make_state('~/.cache/dpp/', '~/.config/nvim/dpp.ts')
```

メッセージ「dpp make_state() is done」が表示されたらNeovimを再起動します。

### 4. プラグインのインストール

Neovimを再起動後、以下のコマンドでプラグインをインストール：

```vim
:call dpp#async_ext_action('installer', 'install')
```

インストール完了後、もう一度Neovimを再起動します。

### 5. deno.jsonのリンク作成（重要）

denopsプラグインが正しく動作するように、deno.jsonへのシンボリックリンクを作成します：

```bash
cd ~/dotfiles
bash dpp_setup.sh link
```

## ディレクトリ構成

```
~/dotfiles/nvim/
├── init.lua                  # Neovimメイン設定（Lua）
├── dpp.ts                    # dpp.vim設定（TypeScript）
├── tomls/                    # プラグイン定義
│   ├── tool.toml             # ツール系プラグイン
│   ├── dpp.toml              # dpp.vim関連
│   └── ddc.toml              # 補完関連（LSP, UI等）
└── lua/                      # Lua設定ファイル
    └── plugins/              # プラグイン個別設定（Lua）

~/.cache/dpp/nvim/            # Neovim専用キャッシュ
```

## VimとNeovimの違い

| 項目 | Vim | Neovim |
|------|-----|--------|
| **メイン設定** | `.vimrc` (VimScript) | `init.lua` (Lua) |
| **設定言語** | VimScript | Lua |
| **dpp.ts** | `~/dotfiles/vim/dpp.ts` | `~/dotfiles/nvim/dpp.ts` |
| **TOML** | `~/dotfiles/vim/tomls/` | `~/dotfiles/nvim/tomls/` |
| **キャッシュ** | `~/.cache/dpp/vim/` | `~/.cache/dpp/nvim/` |

両方は**同じdpp.vimインフラ**を共有していますが、設定ファイルは独立しています。

## dpp.vimの仕組み

### プラグイン管理の流れ

1. **起動時**: `init.lua`でdpp.vimのruntimepathを設定
2. **状態読み込み**: `dpp#min#load_state()`でキャッシュから状態を読み込み
3. **失敗時**: `dpp#make_state()`で`dpp.ts`を実行し状態を生成
4. **プラグイン読み込み**: TOMLファイルからプラグイン定義を読み込み
5. **遅延ロード**: `dpp-ext-lazy`が必要に応じてプラグインを読み込む

### init.luaの重要ポイント

```lua
local dpp_base = "~/.cache/dpp/"
local dpp_config = "~/.config/nvim/dpp.ts"
local dpp_cache = vim.fn.expand("$HOME/.cache/dpp/nvim/.dpp")

-- Luaモジュール検索パス設定
package.path = dpp_cache .. "/lua/?.lua;" .. package.path

-- dpp起動
if vim.fn["dpp#min#load_state"](dpp_base) then
  vim.cmd("autocmd User DenopsReady call dpp#make_state(...)")
end
```

### TOMLファイルの役割

- **tool.toml**: nvim-tree等の一般ツール
- **dpp.toml**: dpp.vim関連の拡張機能
- **ddc.toml**: 補完システム（LSP, UI, sources等）

### 遅延ロードの例

```toml
[[plugins]]
repo = 'Shougo/ddc.vim'
depends = ['denops.vim']
on_event = ['InsertEnter', 'CmdlineEnter']
lua_source = '''
require('plugins.ddc')
'''
```

## 補完システム（ddc.vim）

### アーキテクチャ

```
ユーザー入力
    ↓
ddc.vim (補完エンジン)
    ↓
├─ ddc-source-lsp → nvim-lsp → gopls (Go補完)
├─ ddc-source-around → バッファテキスト
└─ ddc-source-file → ファイルパス
    ↓
ddc-matcher_head (フィルタリング)
    ↓
ddc-sorter_rank (ソート)
    ↓
pum.vim (ポップアップ表示)
```

### キーバインド（デフォルト）

- `Tab`: 補完候補を次へ
- `Shift+Tab`: 補完候補を前へ
- `Ctrl+y`: 補完を確定
- `Ctrl+e`: 補完をキャンセル

Lua設定でカスタマイズ可能です。

## 自動フォーマット

保存時に以下のファイルタイプを自動フォーマット（設定されている場合）：

- **Go (*.go)**: `gofmt`または`gopls`
- **TypeScript (*.ts)**: `efm-langserver`経由
- **Lua (*.lua)**: `efm-langserver`または`stylua`

### Lua設定例

```lua
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})
```

## 表示設定

### タブ幅（デフォルト）

```lua
vim.opt.tabstop = 2       -- タブ幅2
vim.opt.shiftwidth = 2    -- インデント幅2
vim.opt.expandtab = false -- タブ文字を使用
```

### 可視化

```lua
vim.opt.list = true
vim.opt.listchars = { tab = '»·', space = '·', trail = '~' }
```

## トラブルシューティング

### 補完が動作しない

1. **denopsが動作しているか確認**:
   ```vim
   :echo denops#server#status()
   ```
   → `running`と表示されるはず

2. **LSPサーバーが起動しているか確認**:
   ```vim
   :LspInfo
   ```
   または
   ```vim
   :lua vim.print(vim.lsp.get_active_clients())
   ```

3. **手動で補完を試す**:
   `fmt.`と入力後、`<Tab>`または`<C-x><C-o>`で補完が出るか確認

### Luaエラーが出る

1. **init.luaの構文チェック**:
   ```bash
   nvim --headless -c "luafile ~/.config/nvim/init.lua" -c "q"
   ```

2. **エラーメッセージの確認**:
   ```vim
   :messages
   ```

### deno.jsonが見つからないエラー

```bash
cd ~/dotfiles
bash dpp_setup.sh link
```

でシンボリックリンクを作成してください。

### Luaモジュールが見つからない

`package.path`の設定を確認：
```vim
:lua print(package.path)
```

キャッシュディレクトリ（`~/.cache/dpp/nvim/.dpp/lua`）が含まれているか確認してください。

## プラグインの更新

```vim
:call dpp#async_ext_action('installer', 'update')
```

## Vimとの互換性

同じ`dpp_setup.sh`でVimとNeovim両方をセットアップできます。プラグインのリポジトリは共有されますが、キャッシュと設定は独立しています。

## 参考資料

- [dpp.vim公式](https://github.com/Shougo/dpp.vim)
- [dpp.vim導入ガイド（Zenn）](https://zenn.dev/comamoca/articles/howto-setup-dpp-vim)
- [ddc.vim](https://github.com/Shougo/ddc.vim)
- [Neovim公式](https://neovim.io/)
- [gopls](https://github.com/golang/tools/tree/master/gopls)

## ライセンス

各プラグインはそれぞれのライセンスに従います。
