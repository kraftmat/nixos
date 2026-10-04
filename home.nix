{ config, pkgs, lib, pkgs-stable, inputs, fjordlauncher, hostName, flakePath, hostConfig, ... }:

{
  imports = [
    ./cfg/dms.nix
    ./cfg/niri.nix
    ./cfg/qtct.nix
    ./modules/floorp-matugen.nix
  ];

  # ── Пакеты ────────────────────────────────────────────────────────────────
  home.packages = with pkgs; [
  	krita
    xwayland-satellite
    wl-clipboard
    brightnessctl
    pwvucontrol
    libinput
    evtest
    playerctl
    cliphist
    yt-dlp
    btop
    nautilus
    papers
    showtime
    loupe
    gnome-clocks
    gnome-system-monitor
    bibata-cursors
    morewaita-icon-theme
    gh
    steam 
    gamemode
    mangohud
    protonup-qt
    floorp-bin
    gvfs
    nerd-fonts.jetbrains-mono
    inter-nerdfont
    qbittorrent
	wineWow64Packages.stable
    deadlock-mod-manager
    materialgram
    thunderbird
    lutris
    btrfs-assistant
    adw-gtk3
    (inputs.fjordlauncher.packages.${pkgs.stdenv.hostPlatform.system}.fjordlauncher.override {
      jdks = with pkgs; [ zulu zulu21 zulu17 temurin-bin-17  zulu8 zulu25 ];
    })
    lua
    inter
    go
    gamescope
    pkgs-stable.strawberry
    hyfetch
    mumble
	irssi
	compsize
	valent

  ] ++ lib.optionals hostConfig.enableLact [
    pkgs.lact
    pkgs.llama-cpp-vulkan
  ];

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

  programs.micro = {
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

  dconf.settings = {
    "org/gnome/nautilus/preferences" = {
      show-image-thumbnails = "always";
    };
  };
  
  # ── EasyEffects ───────────────────────────────────────────────────────────
  services.easyeffects.enable = true;
  

  # ыы  дискорд  ыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыы
	programs.equibop = {
	  enable = true;
	  settings = {
	    arRPC = true;
	    checkUpdates = true;
	    customTitleBar = false;
	    disableMinSize = true;
	    minimizeToTray = true;
	    tray = true;
	    splashTheming = true;
	    staticTitle = true;
	    hardwareAcceleration = true;
	    discordBranch = "stable";
	  };
	  equicord = {
	    extraQuickCss = builtins.readFile ./cfg/dank-discord.css;
	    settings = {
	      notifyAboutUpdates = false;
	      useQuickCss = true;
	      plugins = {
	        FakeNitro.enabled = true;
	        QuickReply.enabled = true;
	        NoBlockedMessages.enabled = true;
	        BlurNSFW.enabled = true; 
	        NoMiddleClickPaste.enabled = true;
	        NoPushToTalk.enabled = true; 
	        NoReplyMention.enabled = true;
	        ServerInfo.enabled = true;
	        Timezones.enabled = true;
	        ShowHiddenChannels.enabled =true;
	        ReadAllNotificationsButton.enabled = true; 
	        MessageLogger = {
	          enabled = true;
	          ignoreSelf = true;
	        };
	      };
	    };
	  };
	};

  # ── nixMonitor plugin config ──────────────────────────────────────────────
  xdg.configFile."DankMaterialShell/plugins/NixMonitor/config.json".text = builtins.toJSON {
    generationsCommand = [ "sh" "-c" "ls -d /nix/var/nix/profiles/system-*-link 2>/dev/null | wc -l" ];
    storeSizeCommand = [ "sh" "-c" "sudo -n /run/current-system/sw/bin/compsize /nix/store 2>/dev/null | awk '$1==\"TOTAL\"{print $3}'" ];
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

  # ── Git ───────────────────────────────────────────────────────────────────
  programs.git = {
    enable = true;
    settings = {
      user = {
        name  = "kraftmat";
        email = "kraftmat@cerf.ygg";
      };
      credential."https://github.com".helper   = "!gh auth git-credential";
      credential."https://gist.github.com".helper = "!gh auth git-credential";
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
    build-switch-slow = "sudo nixos-rebuild switch --flake ${flakePath} --option substituters 'https://cache.nixos.org' --cores (math -s0 (nproc) '* 40 / 100')";
    build-boot-slow   = "sudo nixos-rebuild boot   --flake ${flakePath} --option substituters 'https://cache.nixos.org' --cores (math -s0 (nproc) '* 40 / 100')";
    ll           = "ls -lah";
  };
  };
  # ── Ghostty ───────────────────────────────────────────────────────────────
  programs.ghostty = {
  	enable                = true;
  	enableFishIntegration = true; 
  	settings = {
  	theme                           = "dankcolors";
  	font-family                     = "JetBrainsMono Nerd Font";
  	font-size                       = 12;
  	window-padding-y                = 15;
  	window-padding-x                = 15; 
  	notify-on-command-finish        = "unfocused";
  	right-click-action              = "ignore";
  	notify-on-command-finish-action = "notify";
  	clipboard-read                  = "allow";
  	clipboard-write                 = "allow";
  	  	keybind = [
  		"performable:ctrl+c=copy_to_clipboard"
  		"alt+t=new_tab"
  		"alt+c=close_surface"
  		"alt+x=next_tab"
  		"alt+z=previous_tab"
  	];
  	};
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
