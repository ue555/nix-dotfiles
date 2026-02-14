# Vim設定 with dpp.vim

dpp.vimを使用したVimの設定セットアップガイド

## 動作環境

- **Vim**: 9.0.1276以上
- **Neovim**: 0.10.0以上
- **Deno**: denops.vim用（必須）
- **Go**: gopls（Go言語補完用）
- **efm-langserver**: TypeScript/Lua等のフォーマット用（オプション）

## 特徴

このVim設定は以下の機能を提供します：

- **dpp.vim**: 高速なプラグインマネージャー（遅延ロード対応）
- **ddc.vim**: LSPベースの自動補完（denops製）
- **vim-lsp**: LSPクライアント（gopls, efm-langserver対応）
- **保存時自動フォーマット**: Go, TypeScript, Luaファイル対応
- **NERDTree**: ファイルツリー
- **vim-go**: Go言語サポート

## セットアップ手順

### 1. 必要なツールのインストール

```bash
# Deno (denops.vim用)
curl -fsSL https://deno.land/install.sh | sh

# gopls (Go言語LSP)
go install golang.org/x/tools/gopls@latest

# efm-langserver (オプション)
go install github.com/mattn/efm-langserver@latest

# gofmt (Go標準ツール)
# Goをインストールすれば含まれています
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
- シンボリックリンクの作成（`.vimrc`, `~/.config/nvim`）

### 3. Vimの起動と初期化

初回起動時にプラグインの状態を生成します：

```bash
vim
```

Vim内で以下のコマンドを実行（初回のみ）：

```vim
:call dpp#make_state('~/.cache/dpp/', '~/dotfiles/vim/dpp.ts')
```

メッセージ「dpp make_state() is done」が表示されたらVimを再起動します。

### 4. プラグインのインストール

Vimを再起動後、以下のコマンドでプラグインをインストール：

```vim
:call dpp#async_ext_action('installer', 'install')
```

インストール完了後、もう一度Vimを再起動します。

### 5. deno.jsonのリンク作成（重要）

denopsプラグインが正しく動作するように、deno.jsonへのシンボリックリンクを作成します：

```bash
cd ~/dotfiles
bash dpp_setup.sh link
```

## ディレクトリ構成

```
~/dotfiles/vim/
├── .vimrc                    # Vimメイン設定
├── dpp.ts                    # dpp.vim設定（TypeScript）
├── deno.json                 # Deno設定
├── deno.lock                 # Denoロックファイル
├── tomls/                    # プラグイン定義
│   ├── tool.toml             # ツール系プラグイン
│   ├── dpp.toml              # dpp.vim関連
│   └── ddc.toml              # 補完関連（LSP, UI等）
├── plugins/                  # プラグイン個別設定
│   ├── ddc.rc.vim            # 補完・LSP設定
│   ├── vim-go.rc.vim         # Go設定
│   └── nerdtree.rc.vim       # NERDTree設定
├── rc/                       # Vim基本設定
│   ├── settings.vim          # 表示・インデント設定
│   ├── keymaps.vim           # キーマップ
│   └── filetype.vim          # ファイルタイプ設定
├── scripts/                  # 自作スクリプト
└── efm-langserver/           # efm-langserver設定
    └── config.yaml
```

## dpp.vimの仕組み

### プラグイン管理の流れ

1. **起動時**: `.vimrc`でdpp.vimのruntimepathを設定
2. **状態読み込み**: `dpp#min#load_state()`でキャッシュから状態を読み込み
3. **失敗時**: `dpp#make_state()`で`dpp.ts`を実行し状態を生成
4. **プラグイン読み込み**: TOMLファイルからプラグイン定義を読み込み
5. **遅延ロード**: `dpp-ext-lazy`が必要に応じてプラグインを読み込む

### TOMLファイルの役割

- **tool.toml**: NERDTree等の一般ツール
- **dpp.toml**: dpp.vim関連の拡張機能
- **ddc.toml**: 補完システム（LSP, UI, sources等）

### 遅延ロードの例

```toml
[[plugins]]
repo = 'Shougo/ddc.vim'
depends = ['denops.vim']
on_event = ['InsertEnter', 'CmdlineEnter']  # インサートモード時に読み込み
hook_source = '''
source $HOME/dotfiles/vim/plugins/ddc.rc.vim
'''
```

## 補完システム（ddc.vim）

### アーキテクチャ

```
ユーザー入力
    ↓
ddc.vim (補完エンジン)
    ↓
├─ ddc-source-lsp → vim-lsp → gopls (Go補完)
├─ ddc-source-around → バッファテキスト
└─ ddc-source-file → ファイルパス
    ↓
ddc-matcher_head (フィルタリング)
    ↓
ddc-sorter_rank (ソート)
    ↓
pum.vim (ポップアップ表示)
```

### LSP設定

`plugins/ddc.rc.vim`で以下を設定：

- **omnifunc**: `lsp#complete`で補完を有効化
- **gopls**: Go言語LSPサーバーの設定
- **efm-langserver**: TypeScript/Lua用フォーマッター
- **自動フォーマット**: 保存時（`:w`）に自動実行

### キーバインド

- `Tab`: 補完候補を次へ
- `Shift+Tab`: 補完候補を前へ
- `Ctrl+y`: 補完を確定
- `Ctrl+e`: 補完をキャンセル

## 自動フォーマット

保存時（`:w`）に以下のファイルタイプを自動フォーマット：

- **Go (*.go)**: `gofmt`
- **TypeScript (*.ts)**: `efm-langserver`経由
- **Lua (*.lua)**: `efm-langserver`経由

### フォーマット設定

`plugins/ddc.rc.vim`:
```vim
function! s:format_on_save() abort
  if &filetype ==# 'go'
    silent! execute '%!gofmt'
  elseif exists(':LspDocumentFormat') == 2
    call execute('LspDocumentFormat')
  endif
endfunction

autocmd BufWritePre *.lua,*.ts,*.go call s:format_on_save()
```

## 表示設定

### タブ幅

`rc/settings.vim`で設定：
```vim
set tabstop=2       " タブ幅2
set shiftwidth=2    " インデント幅2
set noexpandtab     " タブ文字を使用（スペースに展開しない）
```

Goファイルはタブ文字を使用（gofmt標準）し、表示幅のみ2に設定。

### 可視化

```vim
set list
set listchars=tab:»·,space:·,trail:~
```

タブを`»·`、スペースを`·`で表示。

## トラブルシューティング

### 補完が動作しない

1. **denopsが動作しているか確認**:
   ```vim
   :echo denops#server#status()
   ```
   → `running`と表示されるはず

2. **LSPサーバーが起動しているか確認**:
   ```vim
   :LspStatus
   ```
   → goplsが`running`と表示されるはず

3. **omnifuncが設定されているか確認**:
   ```vim
   :set omnifunc?
   ```
   → `omnifunc=lsp#complete`と表示されるはず

4. **手動で補完を試す**:
   `fmt.`と入力後、`<Tab>`または`<C-x><C-o>`で補完が出るか確認

### フォーマットが動作しない

1. **gofmtがインストールされているか**:
   ```bash
   which gofmt
   gofmt -version
   ```

2. **手動でフォーマットを試す**:
   ```vim
   :LspDocumentFormat
   ```

3. **構文エラーがないか確認**:
   フォーマットツールは構文エラーがあるファイルを処理できません

### deno.jsonが見つからないエラー

```bash
cd ~/dotfiles
bash dpp_setup.sh link
```

でシンボリックリンクを作成してください。

## プラグインの更新

```vim
:call dpp#async_ext_action('installer', 'update')
```

## 参考資料

- [dpp.vim公式](https://github.com/Shougo/dpp.vim)
- [dpp.vim導入ガイド（Zenn）](https://zenn.dev/comamoca/articles/howto-setup-dpp-vim)
- [ddc.vim](https://github.com/Shougo/ddc.vim)
- [vim-lsp](https://github.com/prabirshrestha/vim-lsp)
- [gopls](https://github.com/golang/tools/tree/master/gopls)

## ライセンス

各プラグインはそれぞれのライセンスに従います。
