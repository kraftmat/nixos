{ hostName, ... }:

{
  xdg.configFile."DankMaterialShell/plugins/NixMonitor/config.json".text = builtins.toJSON {
    generationsCommand = [ "sh" "-c" "ls -d /nix/var/nix/profiles/system-*-link 2>/dev/null | wc -l" ];
    storeSizeCommand   = [ "sh" "-c" "sudo -n /run/current-system/sw/bin/compsize /nix/store 2>/dev/null | awk '$1==\"TOTAL\"{print $3}'" ];
    rebuildCommand     = [ "bash" "-c" "sudo nixos-rebuild switch --flake /etc/nixos#${hostName} 2>&1" ];
    gcCommand          = [ "sh" "-c" "nix-collect-garbage -d 2>&1" ];
    updateInterval     = 3600;
  };
}
