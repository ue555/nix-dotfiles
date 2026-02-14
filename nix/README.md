# Nix Darwin 構成

macOS の環境構築を nix-darwin + Homebrew で宣言的に管理する。

## 前提条件

- macOS (Apple Silicon)
- Homebrew がインストール済み

## 1. Nix のインストール

```bash
curl -L https://nixos.org/nix/install | sh
```

インストール後、ターミナルを再起動する。

## 2. experimental-features の有効化

ユーザー用とシステム全体（sudo 用）の両方に設定する。

```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
```

## 3. 動作確認

```bash
nix --version
```

## 4. 既存の設定ファイルの退避

nix-darwin が `/etc/bashrc` や `/etc/zshrc` を管理するため、既存ファイルが競合してエラーになる。初回のみリネームが必要。

```bash
sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
```

## 5. nix-darwin の初回適用

システム変更に root 権限が必要なため `sudo` をつけて実行する。

```bash
sudo nix run nix-darwin -- switch --flake /Users/kouji/dotfiles/nix#default
```

## 6. 設定変更後の再適用

初回適用後は `darwin-rebuild` が使えるようになる。

```bash
sudo darwin-rebuild switch --flake /Users/kouji/dotfiles/nix#default
```

## ホスト名の変更

別のマシンで使う場合は `flake.nix` の `hostname` を変更する。

```nix
hostname = "hero555noMacBook-Pro";  # ← 自分のマシンのホスト名に変更
```

ホスト名は以下で確認できる。

```bash
scutil --get LocalHostName
```

## 構成ファイル

| ファイル | 内容 |
|---|---|
| `flake.nix` | 入力ソースと darwinConfigurations の定義 |
| `darwin-configuration.nix` | パッケージ・Homebrew・システム設定 |

## 管理対象

### Nix パッケージ (`environment.systemPackages`)

- mise

### Homebrew brews

- gh
- jq

### Homebrew casks

`darwin-configuration.nix` の `casks` に追加して `darwin-rebuild switch` で反映。
