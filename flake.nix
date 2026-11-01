{
  description = "Horon's NixOS flake";
  inputs = {
    # 跟踪 nixos-unstable，具体版本由 flake.lock 锁定。
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin = {
      url = "github:catppuccin/nix/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    omp = {
      url = "github:can1357/oh-my-pi";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # 固定上游源码的 Magpie 打包，附 magpie.cachix.org 缓存。
    magpie = {
      url = "git+https://forge.asnk.io/sugar/magpie";
    };
  };
  outputs =
    {
      nixpkgs,
      home-manager,
      catppuccin,
      omp,
      magpie,
      ...
    }:
    let
      mkNixosHost = import ./lib/mkNixosHost.nix {
        inherit
          nixpkgs
          home-manager
          catppuccin
          omp
          magpie
          ;
      };
    in
    {
      nixosConfigurations = {
        nixos-vm = mkNixosHost {
          system = "x86_64-linux";
          hostModule = ./hosts/x86_64-linux/nixos-vm;
          username = "horonlee";
          homeModule = ./home/hosts/nixos-vm.nix;
        };
      };
    };
}
