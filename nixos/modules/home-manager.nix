{ inputs, hostName, pkgs-unstable, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";

    extraSpecialArgs = {
      inherit inputs hostName pkgs-unstable;
      inherit (inputs) dms dms-plugin-registry fjordlauncher yapfast;
      flakePath = "/etc/nixos#${hostName}";
    };

    users.kraftmat = {
      imports = [
        inputs.dms.homeModules.dank-material-shell
        inputs.dms-plugin-registry.homeModules.default
        ../../home-manager
      ];
    };
  };
}
