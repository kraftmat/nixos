{ config, pkgs, lib, inputs, hostName, hostConfig, ... }:

{

  # ── Загрузчик ─────────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable      = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint     = "/boot";

  # ── Файловая система ───────────────────────────────────────────────────────
  boot.supportedFilesystems = [ "btrfs" ];

  # ── Ядро ──────────────────────────────────────────────────────────────────
  boot.kernelPackages = pkgs.linuxPackages_zen;
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
  };

  services.xserver.videoDrivers = hostConfig.videoDrivers;

  # NVIDIA Optimus (только для ноута)
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

  # LACT — управление AMD GPU (только для ПК)
  systemd.services.lact = lib.mkIf hostConfig.enableLact {
    description = "AMDGPU Control Daemon";
    enable      = true;
    serviceConfig = {
      ExecStart = "${pkgs.lact}/bin/lact daemon";
    };
    wantedBy = [ "multi-user.target" ];
  };

  # power profiles daemon  — управление питанием (только для ноута)
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

  services.yggdrasil = {
    enable         = true;
    persistentKeys = true;
    settings = {
      Peers = [
        "tls://ip4.01.ekb.ru.dioni.su:9003"
        "wss://assets.route172.de:443/api/request/media?key=00000000000da547036a01860a9e3a0476a525415801ec34f4e5b59fd6055b88"
        "tls://45.95.202.21:443"
      ];
      MulticastInterfaces = [ ];
    };
  };

  systemd.services.zapret-home = {
  	enable 		= lib.mkIf (!hostConfig.enableLact) true;
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
    extraGroups  = [ "networkmanager" "wheel" "input" "render" "video" "audio" ];
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
  ];

  services.upower.enable = lib.mkIf hostConfig.isLaptop true;
  programs.gamemode.enable = true;

  # ── Throne ────────────────────────────────────────────────────────────────
  programs.throne = {
    enable         = true;
    tunMode.enable = true;
  };

  # ── fish ──────────────────────────────────────────────────────────────────
  programs.fish.enable = true;

  # ── niri ──────────────────────────────────────────────────────────────────
  programs.niri.enable = true;
  # DMS has its own polkit agent — disable niri-flake's to avoid conflicts
  systemd.user.services.niri-flake-polkit.enable = false;

  # ── Nix ───────────────────────────────────────────────────────────────────
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
  security.polkit.enable    = true;
  hardware.bluetooth.enable = true;

  system.stateVersion = "26.05";
}
