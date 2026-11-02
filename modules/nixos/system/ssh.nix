{ ... }:
{
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no";
      # 普通用户暂时保留默认的密码与密钥认证。
    };
  };
}
