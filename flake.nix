{
  description = "Horon's NixOS flake";
  inputs = {
    # 跟踪 nixos-unstable，具体版本由 flake.lock 锁定。
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin = {
      url = "github:catppuccin/nix/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # 固定上游源码的 Magpie 打包，附 magpie.cachix.org 缓存。
    magpie = {
      url = "git+https://forge.asnk.io/sugar/magpie";
    };
    # CachyOS latest 内核；release 分支带二进制缓存。
    nix-cachyos-kernel = {
      url = "git+https://github.com/xddxdd/nix-cachyos-kernel?ref=release";
    };
  };
  outputs =
    {
      nixpkgs,
      home-manager,
      catppuccin,
      magpie,
      nix-cachyos-kernel,
      darwin,
      ...
    }:
    let
      mkNixosHost = import ./lib/mkNixosHost.nix {
        inherit
          nixpkgs
          home-manager
          catppuccin
          ;
        overlays = [
          nix-cachyos-kernel.overlays.pinned
          (import ./pkgs/magpie { inherit magpie; })
        ];
      };
      mkDarwinHost = import ./lib/mkDarwinHost.nix {
        inherit
          home-manager
          darwin
          catppuccin
          ;
      };
    in
    {
      nixosConfigurations = {
        nixos-vm = mkNixosHost {
          system = "x86_64-linux";
          hostModule = ./hosts/x86_64-linux/nixos-vm;
          username = "horonlee";
          homeModule = ./home/profiles/linux-desktop-niri.nix;
        };
        # 生成 hosts/x86_64-linux/dell-r430/hardware-configuration.nix
        # 并 git add 后，取消下面的注释。
        dell-r430 = mkNixosHost {
          system = "x86_64-linux";
          hostModule = ./hosts/x86_64-linux/dell-r430;
          username = "horonlee";
          homeModule = ./home/profiles/linux-server.nix;
        };
      };
      darwinConfigurations = {
        mbp-m2pro = mkDarwinHost {
          system = "aarch64-darwin";
          hostModule = ./hosts/aarch64-darwin/mbp-m2pro;
          username = "horonlee";
          homeModule = ./home/profiles/darwin.nix;
        };
      };
    };
}
