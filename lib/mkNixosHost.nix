{ nixpkgs, home-manager }:
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
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${username} = homeModule;
    }
  ];
}
