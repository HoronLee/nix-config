{ lib, appimageTools, fetchurl }:
let
  pname = "nyaterm";
  version = "2.0.1";

  # 更新版本：
  # 1. 修改上面的 version。
  # 2. 重新预取对应 AppImage：
  #    nix store prefetch-file --json \
  #      "https://github.com/nyakang/nyaterm/releases/download/v${version}/NyaTerm_${version}_linux_x64.AppImage"
  # 3. 用返回的 hash 替换下面的值。
  # 4. 如果上游改了产物命名，同步修改 url 和文件名。
  src = fetchurl {
    url = "https://github.com/nyakang/nyaterm/releases/download/v${version}/NyaTerm_${version}_linux_x64.AppImage";
    hash = "sha256-0+PBHjyO/cdaMIS8JZ7F1zSpDtJr/wahjHbaGcHE68M=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapAppImage {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/nyaterm.desktop \
      $out/share/applications/nyaterm.desktop
    install -Dm444 ${appimageContents}/nyaterm.png \
      $out/share/icons/hicolor/128x128/apps/nyaterm.png
  '';

  meta = {
    description = "Native GPUI terminal and SSH client";
    homepage = "https://nyaterm.app";
    license = lib.licenses.asl20;
    mainProgram = "nyaterm";
    platforms = [ "x86_64-linux" ];
  };
}
