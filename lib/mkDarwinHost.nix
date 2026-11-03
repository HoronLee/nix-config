{
  home-manager,
  darwin,
  catppuccin,
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
