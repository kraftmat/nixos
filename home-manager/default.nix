{ ... }:

{
  imports = [
    ./dms.nix
    ./niri.nix
    ./qtct.nix
    ./cfg/floorp-matugen.nix

    ./packages.nix
    ./desktop.nix
    ./shell.nix
    ./git.nix
    ./terminal.nix
    ./obs.nix
    ./micro.nix
    ./equibop.nix
    ./nixmonitor.nix
    ./mangohud.nix
  ];

  home.enableNixpkgsReleaseCheck = false;
}
