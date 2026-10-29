{
  description = "Horon's NixOS flake";

  inputs = {
    # NixOS 官方软件源，这里使用 nixos-26.05 分支
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
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
