{
  description = "kraftmat";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yapfast = {
      url = "github:yapfast/yapfast";
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

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, nur, ... } @ inputs:
    let
      system = "x86_64-linux";

      sharedOverlays = [
        nur.overlays.default
        # (final: prev: {
        #   openldap = prev.openldap.overrideAttrs (_: { doCheck = false; });
        #
        #   llama-cpp-rocm = (prev.llama-cpp.overrideAttrs (old: {
        #     cmakeFlags = (old.cmakeFlags or []) ++ [
        #       "-DGGML_HIP=ON"
        #       "-DAMDGPU_TARGETS=gfx1030"
        #     ];
        #   })).override { rocmSupport = true; };
        # })
      ];

      pkgs-stable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      mkHost = name:
        let
          hostName = "commodore64-${name}";
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs hostName pkgs-stable;
            inherit (inputs) dms dms-plugin-registry fjordlauncher yapfast;
          };
          modules = [
            ./hosts/${name}   
            ./nixos           
            home-manager.nixosModules.home-manager
            { nixpkgs.overlays = sharedOverlays; }
          ];
        };
    in
    {
	nixosConfigurations = builtins.listToAttrs (map
	  (name: { name = "commodore64-${name}"; value = mkHost name; })
	  [ "pc" "laptop" ]);
    };
}
