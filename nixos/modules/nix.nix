{ ... }:

{
  nix.settings = {
    substituters = [ "https://cache.nixos.org" "https://unmojang.cachix.org" ];
    trusted-public-keys = [ "unmojang.cachix.org-1:OfHnbBNduZ6Smx9oNbLFbYyvOWSoxb2uPcnXPj4EDQY=" ];
    trusted-users = [ "root" "kraftmat" ];
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    min-free = 3 * 1024 * 1024 * 1024;
    max-free = 10 * 1024 * 1024 * 1024;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
