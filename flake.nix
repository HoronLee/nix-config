{
  description = "Horon's NixOS flake";

  inputs = {
    # 跟踪 nixos-unstable，具体版本由 flake.lock 锁定。
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      mkNixosHost = import ./lib/mkNixosHost.nix {
        inherit nixpkgs home-manager;
      };
    in
    {
      nixosConfigurations = {
        horon-vm = mkNixosHost {
          system = "x86_64-linux";
          hostModule = ./hosts/x86_64-linux/horon-vm;
          username = "horonlee";
          homeModule = ./home;
        };
      };
    };
}
