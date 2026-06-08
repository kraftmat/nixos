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

  outputs = { nixpkgs, nixpkgs-stable, home-manager, dms, dms-plugin-registry, fjordlauncher, nur, ... } @ inputs:
  let
    sharedOverlays = [
      nur.overlays.default
      (final: prev: {
        openldap = prev.openldap.overrideAttrs (_: { doCheck = false; });
      })
    ];

    mkPkgsStable = import nixpkgs-stable {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };

    mkSystem = { hostname, hostConfig, hardwarePath, hmHostConfig }:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs dms dms-plugin-registry fjordlauncher;
          hostName   = hostname;
          inherit hostConfig;
        };
        modules = [
          hardwarePath
          ./configuration.nix
          home-manager.nixosModules.home-manager

          { nixpkgs.overlays = sharedOverlays; }

          ({ pkgs, ... }: {
            nix.settings = {
              substituters        = [ "https://cache.nixos.org" ];
              trusted-public-keys = [ "unmojang.cachix.org-1:OfHnbBNduZ6Smx9oNbLFbYyvOWSoxb2uPcnXPj4EDQY=" ];
            };

            home-manager = {
              useGlobalPkgs   = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = {
                inherit inputs dms dms-plugin-registry fjordlauncher;
                hostName    = hostname;
                flakePath   = "/etc/nixos#${hostname}";
                hostConfig  = hmHostConfig;
                pkgs-stable = mkPkgsStable;
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
  in
  {
    nixosConfigurations = {

      # ── ПК ────────────────────────────────────────────────────────────────
      kraftmat-pc = mkSystem {
        hostname     = "kraftmat-pc";
        hardwarePath = ./hardware-configuration.nix;

        hostConfig = {
          kernelParams  = [ "amd_pstate=active" "amdgpu.ppfeaturemask=0xffffffff" ];
          initrdModules = [ "amdgpu" ];
          videoDrivers  = [ "amdgpu" ];
          intelCpu      = false;
          enableLact    = true;
          enableTlp     = false;
          nvidia        = null;
          isLaptop      = false;
        };

        hmHostConfig = {
          enableLact  = true;
          isLaptop    = false;
          monitor     = "DP-3";
          mode        = "1920x1080@144";
        };
      };

      # ── Ноут ──────────────────────────────────────────────────────────────
      kraftmat-laptop = mkSystem {
        hostname     = "kraftmat-laptop";
        hardwarePath = ./laptop/hardware-configuration.nix;

        hostConfig = {
          kernelParams  = [ "intel_pstate=active" "nvidia.NVreg_DynamicPowerManagement=0x02" ];
          initrdModules = [ "i915" ];
          videoDrivers  = [ "nvidia" ];
          intelCpu      = true;
          enableLact    = false;
          enableTlp     = true;
          isLaptop      = true;
          nvidia = {
            intelBusId  = "PCI:0:2:0";
            nvidiaBusId = "PCI:1:0:0";
          };
        };

        hmHostConfig = {
          enableLact  = false;
          isLaptop    = true;
          monitor     = "eDP-1";
          mode        = "1920x1080@165";
        };
      };

    };
  };
}
