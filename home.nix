{ config, pkgs, inputs, fjordlauncher, ... }:

{
  imports = [
    ./cfg/dms.nix
    ./cfg/niri.nix
  ];

  # ── Пакеты ────────────────────────────────────────────────────────────────
  home.packages = with pkgs; [
    xwayland-satellite
    wl-clipboard
    brightnessctl
    playerctl
    swayosd
    cliphist
    kdePackages.qt6ct
    libsForQt5.qt5ct
    yt-dlp
    btop
    


    nautilus   
    showtime
    gnome-clocks
    gnome-system-monitor      
    gnome-font-viewer
    bibata-cursors
    morewaita-icon-theme

    vesktop
    gh
    steam
    #lutris
    gamemode
    mangohud
    protonup-qt
    fjordlauncher.packages.${pkgs.system}.fjordlauncher
    floorp-bin

    polkit_gnome
    gvfs
    nerd-fonts.jetbrains-mono
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

  # ── Steam  ────────────────────────────────────────────────────────────────
  home.sessionVariables = {
    STEAM_COMPAT_INVOKER = "PROTON_ENABLE_WAYLAND=1 gamemoderun mangohud";
  };

  # ── Fish ──────────────────────────────────────────────────────────────────
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set fish_greeting ""
    '';

    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake /etc/nixos#kraftmat";
      nrb = "sudo nixos-rebuild boot --flake /etc/nixos#kraftmat";
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
