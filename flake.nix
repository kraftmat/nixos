{
  description = "kraftmat";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fjordlauncher.url = "github:unmojang/FjordLauncher";
  };

  outputs = { nixpkgs, home-manager, dms, dms-plugin-registry, fjordlauncher, ... } @ inputs: {
    nixosConfigurations.kraftmat = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager

        ({ pkgs, ... }: {
          nix.settings = {
            substituters = [ "https://unmojang.cachix.org" ];
            trusted-public-keys = [ "unmojang.cachix.org-1:OfHnbBNduZ6Smx9oNbLFbYyvOWSoxb2uPcnXPj4EDQY=" ];
          };

          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit dms dms-plugin-registry fjordlauncher; };

            users.kraftmat = { imports = [
              dms.homeModules.dank-material-shell
              dms-plugin-registry.modules.default
              ./home.nix
            ]; };
          };
        })
      ];
    };
  };
}
