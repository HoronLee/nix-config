{ ... }:
{
  imports = [
    ../../../modules/darwin
  ];
  networking.hostName = "mbp-m2pro";
  system.stateVersion = 7;
  system.primaryUser = "horonlee";
  users.users.horonlee = {
    name = "horonlee";
    home = "/Users/horonlee";
  };
  my.apps = {
    clash-verge.enable = true;
    ghostty.enable = true;
    obs.enable = true;
  };
}
