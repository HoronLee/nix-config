{
  home-manager,
  darwin,
  catppuccin,
  omp,
}:
{
  system,
  hostModule,
  username,
  homeModule,
}:
darwin.lib.darwinSystem {
  inherit system;
  modules = [
    hostModule
    home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.sharedModules = [
        catppuccin.homeModules.catppuccin
        omp.homeManagerModules.default
      ];
      home-manager.extraSpecialArgs = {
        mylib = import ../lib;
      };
      home-manager.users.${username} = homeModule;
    }
  ];
}
