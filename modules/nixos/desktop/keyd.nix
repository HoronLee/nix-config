{ ... }:
{
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings = {
        main = {
          # 轻按 CapsLock 发送 Escape；按住则进入 capslock 层。
          capslock = "overload(capslock, esc)";
        };
        capslock = {
          # CapsLock + Escape 发送 CapsLock。
          esc = "capslock";
        };
      };
    };
  };
}
