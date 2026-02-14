{
  description = "Nix Darwin configuration with Homebrew";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, ... }:
  let
    # ホスト名を取得するか、デフォルト値を使用
    hostname = "hero555noMacBook-Pro";
  in
  {
    darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";  # Apple Silicon の場合。Intel Mac の場合は "x86_64-darwin"
      modules = [
        ./darwin-configuration.nix
      ];
    };

    # デフォルト設定（任意のホスト名で使用可能）
    darwinConfigurations.default = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./darwin-configuration.nix
      ];
    };
  };
}
