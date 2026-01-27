# Nix Darwin Configuration

macOS用のnix-darwin設定ファイルです。

## 設定を適用するコマンド

```bash
# 初回の場合（nix-darwinをまだインストールしていない場合）
nix run nix-darwin -- switch --flake .#hero555noMac-mini-3

# 2回目以降（darwin-rebuildが使える場合）
darwin-rebuild switch --flake .#hero555noMac-mini-3
```

## その他のコマンド

```bash
# 変更内容を確認（適用せずにビルドのみ）
darwin-rebuild build --flake .#hero555noMac-mini-3

# 設定のテスト（ドライラン）
darwin-rebuild check --flake .#hero555noMac-mini-3
```

## 注意点

- ホスト名が `hero555noMac-mini-3` で設定されています
- 実際のホスト名と異なる場合は、`.#default` を使うか、`flake.nix`のホスト名を修正してください

```bash
# defaultを使う場合
darwin-rebuild switch --flake .#default
```
