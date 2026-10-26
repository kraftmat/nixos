{ ... }:

{
  imports = [
    ./cfg/dms.nix
    ./cfg/niri.nix
    ./cfg/qtct.nix
    ./modules/floorp-matugen.nix

    ./packages.nix
    ./apps.nix
    ./desktop.nix
    ./shell.nix
    ./git.nix
    ./terminal.nix
    ./gaming.nix
  ];

  home.enableNixpkgsReleaseCheck = false;
}
