{
  nixpkgs,
  home-manager,
  catppuccin,
  omp,
  magpie,
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
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.sharedModules = [
        catppuccin.homeModules.catppuccin
        omp.homeManagerModules.default
      ];
      home-manager.extraSpecialArgs = {
        magpieApp = magpie.packages.${system}.magpie-app;
      };
      home-manager.users.${username} = homeModule;
    }
  ];
}
