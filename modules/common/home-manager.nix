{ ... }:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  # 首次部署可写 dotfiles 时保留手动版本，避免 activation 因冲突中止。
  home-manager.backupFileExtension = "hm-backup";
}
