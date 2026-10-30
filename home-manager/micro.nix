{ config, pkgs, ... }:

{
  programs.micro = {
    enable = true;
    settings = {
      clipboard = "terminal";
      colorscheme = "solarized";
      hlsearch = true;
      lsp = true;
      filemanager = true;
    };
  };

  home.activation.installMicroLsp = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD ${pkgs.micro}/bin/micro -plugin install lsp || true
    $DRY_RUN_CMD ${pkgs.micro}/bin/micro -plugin install filemanager || true
  '';
}
