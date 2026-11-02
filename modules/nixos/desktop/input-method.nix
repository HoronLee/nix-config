{ pkgs, ... }:
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = [
        (pkgs.fcitx5-rime.override {
          rimeDataPkgs = [ pkgs.rime-wanxiang ];
        })
      ];

      # 系统默认值；不启用 ignoreUserConfig，保留用户配置和词库写入。
      settings = {
        inputMethod = {
          "Groups/0" = {
            Name = "默认";
            "Default Layout" = "us";
            DefaultIM = "rime";
          };
          "Groups/0/Items/0".Name = "keyboard-us";
          "Groups/0/Items/1".Name = "rime";
          GroupOrder."0" = "默认";
        };
        globalOptions = {
          "Hotkey/TriggerKeys"."0" = "Control+space";
          # AltTriggerKeys 不覆盖，保留 Fcitx 默认的临时 Shift 切换。
        };
      };
    };
  };
}
