{
  nixpkgs,
  home-manager,
  catppuccin,
  overlays ? [ ],
}:
{
  system,
  hostModule,
  username,
  homeModule,
}:
nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    hostModule
    (
      { ... }:
      {
        nixpkgs.overlays = overlays;
      }
    )
    home-manager.nixosModules.home-manager
    {
      home-manager.sharedModules = [
        catppuccin.homeModules.catppuccin
      ];
      home-manager.extraSpecialArgs = {
        mylib = import ../lib;
      };
      home-manager.users.${username} = homeModule;
    }
  ];
}
