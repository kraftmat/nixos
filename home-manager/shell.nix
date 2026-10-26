{ flakePath, ... }:

{
  # ── fetch ─────────────────────────────────────────────────────────────────
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "nixos";
        padding = { right = 1; };
      };
      modules = [
        "title" "separator"
        "os" "host" "kernel" "uptime" "packages" "shell" "terminal"
        "cpu" "gpu" "memory" "disk"
        "break" "colors"
      ];
    };
  };

  # ── Fish ──────────────────────────────────────────────────────────────────
  home.sessionVariables = {
    EDITOR = "micro";
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting ""
    '';
    shellAliases = {
      cn = "cd /etc/nixos";
      ed = "micro";
      build-switch = "sudo nixos-rebuild switch --flake ${flakePath} --option substituters 'https://cache.nixos.org'";
      build-boot = "sudo nixos-rebuild boot --flake ${flakePath} --option substituters 'https://cache.nixos.org'";
      build-switch-slow = "sudo nixos-rebuild switch --flake ${flakePath} --option substituters 'https://cache.nixos.org' --cores (math -s0 (nproc) '* 40 / 100')";
      build-boot-slow = "sudo nixos-rebuild boot --flake ${flakePath} --option substituters 'https://cache.nixos.org' --cores (math -s0 (nproc) '* 40 / 100')";
      ll = "ls -lah";
    };
  };
}
