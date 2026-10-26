{ pkgs, ... }:

{
  users.users.kraftmat = {
    isNormalUser = true;
    description = "kraftmat";
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" "input" "render" "video" "audio" "docker" ];
  };

  security.sudo.extraRules = [
    {
      users = [ "kraftmat" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/nixos-rebuild";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/nix-collect-garbage";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/compsize";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
