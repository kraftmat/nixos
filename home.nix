{ config, pkgs, lib, pkgs-stable, inputs, fjordlauncher, hostName, flakePath, hostConfig, ... }:

{
  imports = [
    ./cfg/dms.nix
    ./cfg/niri.nix
    ./cfg/qtct.nix
  ];

  # ── Пакеты ────────────────────────────────────────────────────────────────
  home.packages = with pkgs; [
    xwayland-satellite
    wl-clipboard
    brightnessctl
    playerctl
    swayosd
    cliphist
    yt-dlp
    btop
    nautilus
    showtime
    gnome-clocks
    gnome-system-monitor
    bibata-cursors
    morewaita-icon-theme
    vesktop
    gh
    steam
    gamemode
    mangohud
    protonup-qt
    floorp-bin
    polkit_gnome
    gvfs
    nerd-fonts.jetbrains-mono
    adw-gtk3
    gnumake
    cmake
    sx

    inputs.fjordlauncher.packages.${pkgs.system}.fjordlauncher

    pkgs-stable.lutris
    throne
  ] ++ lib.optionals hostConfig.enableLact [ 
  pkgs.lact 
  ];

  # ── swayosd ───────────────────────────────────────────────────────────────
  services.swayosd.enable = true;

  # ── EasyEffects ───────────────────────────────────────────────────────────
  services.easyeffects.enable = true;
  xdg.configFile."easyeffects/output/AutoEq.json".source = ./cfg/EF.json;

  # ── fetch ─────────────────────────────────────────────────────────────────
  programs.fastfetch = {
    enable   = true;
    settings = {
      logo = {
        source  = "nixos";
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

  # ── nh ────────────────────────────────────────────────────────────────────
  programs.nh = {
    enable = true;
    clean = {
      enable    = true;
      extraArgs = "--keep 3 --keep-since 10d";
    };
  };

  # ── Fish ──────────────────────────────────────────────────────────────────
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set fish_greeting ""
    '';

    shellAliases = {
      build-switch = "sudo nixos-rebuild switch --flake ${flakePath}";
      build-boot   = "sudo nixos-rebuild boot   --flake ${flakePath}";
      ll           = "ls -lah";
    };
  };

  # ── Kitty ─────────────────────────────────────────────────────────────────
  programs.kitty = {
    enable   = true;
    settings = {
      dynamic_background_opacity = true;
      window_padding_width       = 15;
    };
    extraConfig = ''
      include dank-theme.conf
      include dank-tabs.conf
    '';
  };

  # ── Cursor ────────────────────────────────────────────────────────────────
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package    = pkgs.bibata-cursors;
    name       = "Bibata-Modern-Classic";
    size       = 24;
  };

  # ── MangoHud ──────────────────────────────────────────────────────────────
  xdg.configFile."MangoHud/MangoHud.conf".text = ''
    legacy_layout=0
    horizontal=0
    round_corners=8
    background_alpha=0.6
    background_color=202020
    text_color=FFFFFF
    gpu_color=34A853
    cpu_color=4285F4
    fps_color=FBBC05

    position=top-left
    table_columns=3

    gpu_text=GPU
    gpu_stats
    gpu_temp
    gpu_junction_temp
    gpu_core_clock
    gpu_mem_clock
    gpu_power

    cpu_text=CPU
    cpu_stats
    cpu_temp
    cpu_clock

    vram
    ram

    fps
    frametime
    frame_timing=1
    histogram

    display_server
    engine
    vulkan_driver

    hud_no_margin
  '';

  xdg.enable = true;

  home.stateVersion = "25.11";
}
