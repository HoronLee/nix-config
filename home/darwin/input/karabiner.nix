{ lib, ... }:
{
  # Karabiner 的配置由其 GUI 持续改写，只在文件不存在时注入仓库中的初始配置。
  # 已有机器的运行时配置不会被后续 switch 覆盖。
  home.activation.karabinerSeed = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir -p "$HOME/.config/karabiner"
    if [ ! -e "$HOME/.config/karabiner/karabiner.json" ]; then
      run install -m 600 ${./karabiner/karabiner.json} "$HOME/.config/karabiner/karabiner.json"
    fi
  '';
}
