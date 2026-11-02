{ ... }:
{
  imports = [
    ../../../modules/darwin/apps.nix
  ];

  networking.hostName = "mbp-m2pro";

  system.stateVersion = 7;

  system.primaryUser = "horonlee";

  users.users.horonlee = {
    name = "horonlee";
    home = "/Users/horonlee";
  };

  homebrew.enable = true;

  my.apps = {
    clash-verge.enable = true;
    ghostty.enable = true;
    orbstack.enable = true;
  };
}
