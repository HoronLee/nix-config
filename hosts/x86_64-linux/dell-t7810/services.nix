{ ... }:
{
  my.frpc = {
    enable = true;
    proxies = [
      {
        name = "ssh";
        type = "tcp";
        localPort = 22;
        remotePort = 20003;
      }
    ];
  };
}
