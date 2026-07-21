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
    libinput
    evtest
    playerctl
    cliphist
    yt-dlp
    btop
    nautilus
    showtime
    loupe
    gnome-clocks
    gnome-system-monitor
    bibata-cursors
    morewaita-icon-theme
    vesktop
    gh
    steam # mangohud gamemoderun XKB_DEFAULT_LAYOUT=us,ru XKB_DEFAULT_OPTIONS=grp:caps_toggle gamescope --expose-wayland -- %command%
    gamemode
    mangohud
    protonup-qt
    floorp-bin
    gvfs
    nerd-fonts.jetbrains-mono
    inter-nerdfont
    qbittorrent
    wine
    deadlock-mod-manager
    materialgram
    thunderbird
    (bottles.override { removeWarningPopup = true; })
    btrfs-assistant
    adw-gtk3
    (inputs.fjordlauncher.packages.${pkgs.stdenv.hostPlatform.system}.fjordlauncher.override {
      jdks = with pkgs; [ zulu zulu21 zulu17 temurin-bin-17  zulu8 zulu25 ];
    })
    lua
    inter
    go
    gamescope
    pear-desktop
    pragha
    hyfetch
    mumble
	irssi

  ] ++ lib.optionals hostConfig.enableLact [
    pkgs.lact
    pkgs.llama-cpp-vulkan
  ];

  programs.opencode = {
    enable = true;
    settings = {
      "$schema" = "https://opencode.ai/config.json";
      lsp = true;
      provider = {
        "llama.cpp" = {
          npm = "@ai-sdk/openai-compatible";
          name = "llama-server (local)";
          options.baseURL = "http://127.0.0.1:8080/v1";
          models = {
            "qwen-coder" = {
              name = "Qwen2.5 Coder 7B (local)";
              limit = {
                context = 32768;
                output  = 8192;
              };
            };
          };
        };
      };
    };
  };

   programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      pixel-art
      obs-retro-effects
    ];
  };

  # ── EasyEffects ───────────────────────────────────────────────────────────
  services.easyeffects.enable = true;
  xdg.configFile."easyeffects/output/AutoEq.json".source = ./cfg/EF.json;

  # ── nixMonitor plugin config ──────────────────────────────────────────────
  xdg.configFile."DankMaterialShell/plugins/NixMonitor/config.json".text = builtins.toJSON {
    generationsCommand = [ "sh" "-c" "ls -d /nix/var/nix/profiles/system-*-link 2>/dev/null | wc -l" ];
    storeSizeCommand = [ "sh" "-c" "du -sh /nix/store 2>/dev/null | cut -f1" ];
    rebuildCommand = [ "bash" "-c" "sudo nixos-rebuild switch --flake /etc/nixos#${hostName} 2>&1" ];
    gcCommand = [ "sh" "-c" "nix-collect-garbage -d 2>&1" ];
    updateInterval = 3600;
  };

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

  # ── Fish ──────────────────────────────────────────────────────────────────
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set fish_greeting ""
    '';

  shellAliases = {
    build-switch = "sudo nixos-rebuild switch --flake ${flakePath} --option substituters 'https://cache.nixos.org'";
    build-boot   = "sudo nixos-rebuild boot   --flake ${flakePath} --option substituters 'https://cache.nixos.org'";
    ll           = "ls -lah";
  };
  };
  # ── Kitty ─────────────────────────────────────────────────────────────────
  programs.kitty = {
    enable   = true;
    settings = {
      confirm_os_window_close = 0;
      dynamic_background_opacity = true;
      window_padding_width       = 15;
      font_family                = "JetBrainsMono Nerd Font";
      font_size                  = 12;
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

  home.stateVersion = "26.05";
  home.enableNixpkgsReleaseCheck = false;
}
