{ pkgs, ... }:

{
  programs.fish.enable = true;

  programs.kdeconnect = {
    enable = true;
    package = pkgs.valent;
  };

  virtualisation.docker.enable = false;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    protontricks.enable = true;
  };

  programs.gamemode.enable = true;
}
