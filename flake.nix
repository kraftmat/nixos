{
  description = "kraftmat";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

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

  outputs = { nixpkgs, nixpkgs-stable, home-manager, dms, dms-plugin-registry, fjordlauncher, nur, ... } @ inputs: {
    nixosConfigurations.kraftmat-pc = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs dms dms-plugin-registry fjordlauncher;
        hostName   = "kraftmat-pc";
        hostConfig = {
          kernelParams  = [ "amd_pstate=active" "amdgpu.ppfeaturemask=0xffffffff" ];
          initrdModules = [ "amdgpu" ];
          videoDrivers  = [ "amdgpu" ];
          intelCpu      = false;
          enableLact    = true;
          enableTlp     = false;
          nvidia        = null;
          isLaptop 		= false;
        };
      };
      modules = [
        ./hardware-configuration.nix
        ./configuration.nix
        home-manager.nixosModules.home-manager

        {
          nixpkgs.overlays = [
            nur.overlays.default
            (final: prev: {
              openldap = prev.openldap.overrideAttrs (oldAttrs: {
                doCheck = false;
              });
            })
          ];
        }

        ({ pkgs, ... }: {
          nix.settings = {
            substituters        = [ "https://cache.nixos.org" ];
            trusted-public-keys = [ "unmojang.cachix.org-1:OfHnbBNduZ6Smx9oNbLFbYyvOWSoxb2uPcnXPj4EDQY=" ];
          };

          home-manager = {
            useGlobalPkgs   = true;
            useUserPackages = true;
            extraSpecialArgs = {
              inherit inputs dms dms-plugin-registry fjordlauncher;
              hostName  = "kraftmat-pc";
              flakePath = "/etc/nixos#kraftmat-pc";
              hostConfig = {
                enableLact = true;
                monitor = "DP-3";
                mode    = "1920x1080@144";
              };
              pkgs-stable = import nixpkgs-stable {
                system = "x86_64-linux";
                config.allowUnfree = true;
              };
            };

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
