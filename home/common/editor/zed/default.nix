{ lib, config, ... }:
let
  accent = " (${config.catppuccin.zed.accent})";
  settings = lib.importJSON ./settings.json;
in
{
  programs.zed-editor = {
    enable = true;
    # 扩展在 Zed 首次启动时自动安装；catppuccin-icons 由 catppuccin 模块追加。
    extensions = [
      "nix"
      "sql"
      "toml"
      "json5"
    ];
    userSettings = settings // {
      # Catppuccin 模块默认把 light/dark 都写成 mocha；这里强制改为跟随系统亮暗。
      theme = lib.mkForce {
        mode = "system";
        light = "Catppuccin Latte${accent}";
        dark = "Catppuccin Mocha${accent}";
      };
      icon_theme = lib.mkForce {
        light = "Catppuccin Latte";
        dark = "Catppuccin Mocha";
      };
    };
    userKeymaps = lib.importJSON ./keymap.json;
  };
}
