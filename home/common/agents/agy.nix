{ pkgs, ... }:
let
  # 暂留旧 nixpkgs，仅将 agy 固定到 1.5.3；升级与移除检查见 TODO.md。
  version = "1.5.3";
  wholeVersion = "${version}-6604829099950080";
  hashes = {
    x86_64-linux = "sha256-G0hQWZzOc6F/lP+0It87+VMVMbd9vdxAwaQ14MLBaAc=";
    aarch64-linux = "sha256-LVAGDHsTJ5leXIHsWIKckcJWTruf7BZdP58TJewYhnU=";
    aarch64-darwin = "sha256-tHA04TZ/w8nyhW8eGuML8SgZpyE4Ibo8ziEjsJDy34o=";
  };
in
{
  home.packages = [
    (pkgs.antigravity-cli.overrideAttrs (old: {
      inherit version;
      src = pkgs.fetchurl {
        url = builtins.replaceStrings [ old.passthru.wholeVersion ] [ wholeVersion ] old.src.url;
        hash = hashes.${pkgs.stdenv.hostPlatform.system};
      };
      passthru = old.passthru // {
        inherit wholeVersion;
      };
    }))
  ];
}
