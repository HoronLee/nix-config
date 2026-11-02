{ mylib, ... }:
{
  imports = [
    ../terminals
    ../editor/zed
  ]
  ++ mylib.scanPaths ./.;
}
