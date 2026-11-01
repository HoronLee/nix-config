{ pkgs, lib, ... }:
let
  installer = pkgs.callPackage ../../../pkgs/magpie { };
in
lib.mkIf (pkgs.stdenv.hostPlatform.isLinux || pkgs.stdenv.hostPlatform.isDarwin) {
  home.packages = [ installer ];
  home.activation.magpieInstall = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${installer}/bin/magpie-install
  '';
}
