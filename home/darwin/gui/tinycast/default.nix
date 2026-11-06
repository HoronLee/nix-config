{ config, ... }:
{
  # Tinycast 的偏好存在 UserDefaults，settings.json 只是它的镜像；链接到仓库后，
  # 应用内的修改会写回这个文件。开启镜像本身是应用里的开关（设置 → 备份），
  # 文件里没有对应键，新机器仍需在应用里打开一次。
  xdg.configFile."tinycast/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/projects/nix-config/home/darwin/gui/tinycast/settings.json";
}
