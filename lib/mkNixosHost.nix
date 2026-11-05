{
  nixpkgs,
  home-manager,
  catppuccin,
  magpie,
  nix-cachyos-kernel,
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
        nixpkgs.overlays = [
          nix-cachyos-kernel.overlays.pinned
        ];
      }
    )
    home-manager.nixosModules.home-manager
    {
      home-manager.sharedModules = [
        catppuccin.homeModules.catppuccin
      ];
      home-manager.extraSpecialArgs = {
        mylib = import ../lib;
        # 上游用 os.Executable() 写启动项，会绕过 wrapGAppsHook3 的环境。
        magpieApp = magpie.packages.${system}.magpie-app.overrideAttrs (old: {
          patches = (old.patches or [ ]) ++ [ ../pkgs/magpie/exec-wrapper.patch ];
          preFixup = (old.preFixup or "") + ''
            gappsWrapperArgs+=(--set MAGPIE_EXECUTABLE "$out/bin/magpie-app")
          '';
        });
      };
      home-manager.users.${username} = homeModule;
    }
  ];
}
