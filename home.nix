{ config, pkgs, pkgs-stable, inputs, fjordlauncher, ... }:

{
  imports = [
    ./cfg/dms.nix
    ./cfg/niri.nix
  ];

  # ── Пакеты ────────────────────────────────────────────────────────────────
  home.packages = [
      pkgs.xwayland-satellite
      pkgs.wl-clipboard
      pkgs.brightnessctl
      pkgs.playerctl
      pkgs.swayosd
      pkgs.cliphist
      pkgs.kdePackages.qt6ct
      pkgs.libsForQt5.qt5ct
      pkgs.yt-dlp
      pkgs.btop
      pkgs.nautilus   
      pkgs.showtime
      pkgs.gnome-clocks
      pkgs.gnome-system-monitor      
      pkgs.gnome-font-viewer
      pkgs.bibata-cursors
      pkgs.morewaita-icon-theme
      pkgs.vesktop
      pkgs.gh
      pkgs.steam
      pkgs.gamemode
      pkgs.mangohud
      pkgs.protonup-qt
      pkgs.floorp-bin
      pkgs.polkit_gnome
      pkgs.gvfs
      pkgs.nerd-fonts.jetbrains-mono
      pkgs.adw-gtk3
      
      inputs.fjordlauncher.packages.${pkgs.system}.fjordlauncher
  
      pkgs-stable.lutris
    ];
  
  # ── swayosd  ──────────────────────────────────────────────────────────────
  services.swayosd = {
    enable = true;
  };
  
  # ── EF ────────────────────────────────────────────────────────────────────
  services.easyeffects.enable = true;
  xdg.configFile."easyeffects/output/AutoEq.json".source = ./cfg/EF.json; 

  # ── fetch ───────────────────────────────────────────────────────────────── 	
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "nixos";
        padding = {
          right = 1;
        };
      };
      modules = [
        "title"
        "separator"
        "os"
        "host"
        "kernel"
        "uptime"
        "packages"
        "shell"
        "terminal"
        "cpu"
        "gpu"
        "memory"
        "disk"
        "break"
        "colors"
      ];
    };
  };


  # ── Fish ──────────────────────────────────────────────────────────────────
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set fish_greeting ""
    '';

    shellAliases = {
      build-switch = "sudo nixos-rebuild switch --flake /etc/nixos#kraftmat";
      build-boot = "sudo nixos-rebuild boot --flake /etc/nixos#kraftmat";
      ll  = "ls -lah";
    };
  };
  # ── Qt and GTK  ───────────────────────────────────────────────────────────
  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };


  # ── Kitty ─────────────────────────────────────────────────────────────────
  programs.kitty = {
    enable = true;
    settings = {
      dynamic_background_opacity = true;
      window_padding_width = 15;
    };
    extraConfig = ''
      include dank-theme.conf
      include dank-tabs.conf
    '';
  };

  # ── CursorX11 ─────────────────────────────────────────────────────────────
  home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic"; 
      size = 24;
    };

  # ── mangohud ──────────────────────────────────────────────────────────────
xdg.configFile."MangoHud/MangoHud.conf".text = ''
  legacy_layout=0
  horizontal
  horizontal_stretch=0
  position=top-left
  round_corners=4
  hud_no_margin
  font_size=16
  gpu_text=GPU
  gpu_stats
  gpu_core_clock
  gpu_temp
  cpu_text=CPU
  cpu_stats
  cpu_mhz
  cpu_temp
  ram
  vram
  fps
  frametime=0
  engine_version
  gpu_name
'';


  xdg.enable = true;

  home.stateVersion = "25.11";
}
