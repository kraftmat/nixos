{ config, pkgs, lib, inputs, hostName, hostConfig, ... }:

{

  # ── Загрузчик ─────────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable = false; # сустемд вирусня
  boot.loader.limine.enable = true;
  boot.loader.limine.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.limine.style.wallpapers = [ ./wallpapers/7.jpg ];

  # ── Файловая система ───────────────────────────────────────────────────────
  boot.supportedFilesystems = [ "btrfs" ];

  # ── Ядро ──────────────────────────────────────────────────────────────────
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_stable;
  boot.kernelParams         = hostConfig.kernelParams;
  boot.initrd.kernelModules = hostConfig.initrdModules;
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';

  hardware.cpu.amd.updateMicrocode   = !hostConfig.intelCpu;
  hardware.cpu.intel.updateMicrocode =  hostConfig.intelCpu;

  # ── Графика ───────────────────────────────────────────────────────────────
  hardware.graphics = {
    enable      = true;
    enable32Bit = true;
    extraPackages = lib.optionals hostConfig.intelCpu [
		pkgs.intel-media-driver
		pkgs.libva-vdpau-driver
		pkgs.libvdpau-va-gl
    ];
  };
  
  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  } // lib.optionalAttrs hostConfig.intelCpu {
    LIBVA_DRIVER_NAME = "iHD";
  } // lib.optionalAttrs hostConfig.isLaptop {
    WLR_DRM_DEVICES = "/dev/dri/card1";
  };
  services.xserver.videoDrivers = hostConfig.videoDrivers;

  # NVIDIA Optimus
  hardware.nvidia = lib.mkIf (hostConfig.nvidia != null) {
    modesetting.enable = true;
    powerManagement = {
      enable      = true;
      finegrained = true;
    };
    open           = false;
    nvidiaSettings = true;
    package        = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      offload = {
        enable           = true;
        enableOffloadCmd = true;
      };
      intelBusId  = hostConfig.nvidia.intelBusId;
      nvidiaBusId = hostConfig.nvidia.nvidiaBusId;
    };
  };

  # LACT
  systemd.services.lact = lib.mkIf hostConfig.enableLact {
    description = "AMDGPU Control Daemon";
    enable      = true;
    serviceConfig = {
      ExecStart = "${pkgs.lact}/bin/lact daemon";
    };
    wantedBy = [ "multi-user.target" ];
  };

  # power profiles daemon
  services.power-profiles-daemon.enable = lib.mkIf hostConfig.isLaptop true;

  # ── Zram ──────────────────────────────────────────────────────────────────
  zramSwap = {
    enable    = true;
    algorithm = "zstd";
  };

  # ── Сеть ──────────────────────────────────────────────────────────────────
  networking.hostName              = hostName;
  networking.networkmanager.enable = true;
  networking.interfaces.enp3s0.wakeOnLan.enable = true;
  networking.networkmanager.dns = "none";
  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
    "8.8.8.8"
    "8.8.4.4"
    "77.88.8.8"
    "77.88.8.1"
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
    allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
  };

  services.yggdrasil = {
    enable         = true;
    settings = {
      Peers = [
	"tls://45.95.202.21:443"
	"tls://45.147.200.202:443"
	"tls://yg-vvo.magicum.net:29331"
	"tls://ygg1.mk16.de:1338?key=0000000087ee9949eeab56bd430ee8f324cad55abf3993ed9b9be63ce693e18a"
	"tls://ygg2.mk16.de:1338?key=000000d80a2d7b3126ea65c8c08fc751088c491a5cdd47eff11c86fa1e4644ae"
	"tls://reticulum.me:12393?key=a3d411280dfc350a4484aa3da5feb0407518c5820cbb011d5620347769b26665"
      ];
      MulticastInterfaces = [ ];
    };
  };
  
  

  systemd.services.zapret-home = {
  	enable 		= false;
    description = "Zapret";
    after       = [ "network.target" ];
    wantedBy    = [ "multi-user.target" ];

    path = with pkgs; [ iptables nftables gawk procps curl git coreutils gnused gnugrep bash ];

    serviceConfig = {
      Type             = "simple";
      User             = "root";
      WorkingDirectory = "/home/kraftmat/zapret-discord-youtube-linux";
      ExecStart        = "${pkgs.bash}/bin/bash service.sh run -c conf.env";
      Restart          = "on-failure";
      RestartSec       = "5s";
    };
  };

  services.cloudflare-warp.enable = true;

  services.zerotierone = {
    enable = true;
    joinNetworks = [
      "b9a18a606ffecb53"
    ];
  };

  # ── Локаль / время ────────────────────────────────────────────────────────
  time.timeZone      = "Europe/Riga";
  i18n.defaultLocale = "en_US.UTF-8";

  # ── Пользователь ──────────────────────────────────────────────────────────
  users.users.kraftmat = {
    isNormalUser = true;
    description  = "kraftmat";
    shell        = pkgs.fish;
    extraGroups  = [ "networkmanager" "wheel" "input" "render" "video" "audio" "docker" ];
  };

  # ── Системные пакеты ──────────────────────────────────────────────────────
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    micro
    git
    wget
    fastfetch
    nftables
    procps
    screen
    ffmpeg
    nixd
    nixfmt-rfc-style
    statix
    cloudflare-warp
    cloudflared
    compsize
    valent
  ];
  
  programs.kdeconnect = {
    enable = true;
    package = pkgs.valent;
  };
  
  programs.steam = {
  enable = true; 
  remotePlay.openFirewall = true;
  dedicatedServer.openFirewall = true; 
  protontricks.enable = true;
  };
  services.upower.enable = lib.mkIf hostConfig.isLaptop true;
  programs.gamemode.enable = true;
  virtualisation.docker.enable = true;
  services.gvfs.enable = true;
  
  # ── Throne ────────────────────────────────────────────────────────────────
  programs.throne = {
    enable         = true;
    tunMode.enable = true;
  };

  # ── fonts  ────────────────────────────────────────────────────────────────
  fonts.packages = with pkgs; [
    inter-nerdfont
  ];

  # ── fish ──────────────────────────────────────────────────────────────────
  programs.fish.enable = true;

  # ── niri ──────────────────────────────────────────────────────────────────
  programs.niri.enable = true;
  systemd.user.services.niri-flake-polkit.enable = false;

  # ── Nix ───────────────────────────────────────────────────────────────────
    nix.settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store   = true;   
      min-free = 3  * 1024 * 1024 * 1024;  
      max-free = 10 * 1024 * 1024 * 1024;  
    };
  
    nix.gc = {
      automatic = true;
      dates     = "weekly";
      options   = "--delete-older-than 7d";
    };

  # ── Snapper  ──────────────────────────────────────────────────────────────
  services.snapper = {
    snapshotInterval = "hourly";
    cleanupInterval  = "1d";
    configs.home = {
      SUBVOLUME        = "/home";
      ALLOW_USERS      = [ "kraftmat" ];
      TIMELINE_CREATE  = true;
      TIMELINE_CLEANUP = true;
      TIMELINE_MIN_AGE    = "1800";
      TIMELINE_LIMIT_HOURLY  = "5";
      TIMELINE_LIMIT_DAILY   = "7";
      TIMELINE_LIMIT_WEEKLY  = "0";
      TIMELINE_LIMIT_MONTHLY = "0";
      TIMELINE_LIMIT_YEARLY  = "0";
    };
  };

  systemd.tmpfiles.rules = [
    "d /home/.snapshots 0750 root kraftmat -"
  ];
  # ── Звук ──────────────────────────────────────────────────────────────────
  services.pipewire = {
    enable             = true;
    alsa.enable        = true;
    pulse.enable       = true;
    wireplumber.enable = true;
  };
  security.rtkit.enable = true;

  xdg.portal = {
    enable       = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    config.common.default = "gnome";
  };

  # ── Display manager ───────────────────────────────────────────────────────
  services.displayManager.ly = {
  enable   = true;
  settings = {
    animation     = "dur_file";
    dur_file_path = "${./cfg/blackhole-smooth-240x67.dur}";
    full_color    = true;
    bigclock      = true;
  };
};

  # ── SSH ───────────────────────────────────────────────────────────────────
  services.openssh.enable = true;
  services.openssh.ports  = [ 2222 ];

  # ── Прочее ────────────────────────────────────────────────────────────────
  security.sudo.extraRules = [
    {
      users = [ "kraftmat" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/nixos-rebuild";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/nix-collect-garbage";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/compsize";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  security.polkit.enable    = true;
  hardware.bluetooth.enable = true;

  system.stateVersion = "26.05";
}
