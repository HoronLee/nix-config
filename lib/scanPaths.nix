# Return the .nix files in `path`, excluding default.nix.
# Subdirectories are not traversed; composition stays explicit.
path:
let
  entries = builtins.readDir path;
  names = builtins.attrNames entries;
  isModule =
    name:
    entries.${name} == "regular" && name != "default.nix" && builtins.match ".*\\.nix" name != null;
in
map (name: path + "/${name}") (builtins.filter isModule names)
