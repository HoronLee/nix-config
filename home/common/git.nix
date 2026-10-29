{ ... }:
{
  programs.git = {
    enable = true;
    settings.user = {
      name = "HoronLee";
      email = "horonlee@foxmail.com";
    };
  };
  programs.lazygit.enable = true;
}
