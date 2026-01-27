{ config, pkgs, ... }:

{
  # Nix の設定
  # Determinate Nix を使用しているため、nix-darwin の Nix 管理を無効化
  nix.enable = false;

  # Homebrew の設定
  homebrew = {
    enable = true;

    # brew install で入れるパッケージ
    brews = [
      "gh"
      "jq"
      "neovim"
    ];

    # brew install --cask で入れるアプリケーション（必要に応じて追加）
    casks = [
      # "google-chrome"
      # "visual-studio-code"
    ];

    # Mac App Store からインストールするアプリ（必要に応じて追加）
    # masApps = {
    #   "Xcode" = 497799835;
    # };

    # nix-darwin で管理されていないパッケージの扱い
    onActivation = {
      # "zap" にすると管理外のパッケージを削除
      # "uninstall" にすると管理外のパッケージをアンインストール
      # "none" にすると何もしない
      cleanup = "none";

      # 自動的に brew update を実行
      autoUpdate = true;

      # 自動的に brew upgrade を実行
      upgrade = true;
    };
  };

  # システム設定
  system = {
    # 設定変更を追跡するためのバージョン
    stateVersion = 5;

    # darwin-rebuild を実行するユーザー（homebrew.enable に必要）
    primaryUser = "kouji";
  };

  # プログラムの設定
  programs = {
    # デフォルトシェルの設定（必要に応じて）
    zsh.enable = true;
  };

  # Nix パッケージでインストールするもの
  environment.systemPackages = with pkgs; [
    mise
  ];
}
