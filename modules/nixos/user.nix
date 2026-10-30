{ pkgs, ... }:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."horonlee" = {
    isNormalUser = true;
    description = "HoronLee";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
    packages = with pkgs; [
      kdePackages.kate
      #  thunderbird
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHqwD3dxo4rb4XSVcec42OBNjXZq0/au58YV3RwvPBDk horonlee@foxmail.com"
    ];
  };

  programs.fish.enable = true;
}
