{ config, pkgs, lib, inputs, hostName, hostConfig, ... }:

{

  # ── Загрузчик ─────────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable      = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint     = "/boot";

  # ── Файловая система ───────────────────────────────────────────────────────
  boot.supportedFilesystems = [ "btrfs" ];

  # ── Ядро ──────────────────────────────────────────────────────────────────
  boot.kernelParams         = hostConfig.kernelParams;
  boot.initrd.kernelModules = hostConfig.initrdModules;

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

  # TLP — управление питанием (только для ноута)
  services.tlp = lib.mkIf hostConfig.enableTlp {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC    = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT   = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC  = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      RUNTIME_PM_ON_AC              = "auto";
      RUNTIME_PM_ON_BAT             = "auto";
    };
  };

  # ── Zram ──────────────────────────────────────────────────────────────────
  zramSwap = {
    enable    = true;
    algorithm = "zstd";
  };

  # ── Сеть ──────────────────────────────────────────────────────────────────
  networking.hostName              = hostName;
  networking.networkmanager.enable = true;

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
    description = "Zapret";
    after       = [ "network.target" ];
    wantedBy    = [ "multi-user.target" ];

    path = with pkgs; [ iptables nftables gawk procps curl git coreutils gnused gnugrep bash ];

    serviceConfig = {
      Type             = "simple";
      User             = "root";
      WorkingDirectory = "/home/kraftmat/zapret-discord-youtube-linux";
      ExecStart        = "/run/current-system/sw/bin/bash service.sh run -c conf.env";
      Restart          = "on-failure";
      RestartSec       = "5s";
    };
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
  ];

  services.upower.enable = lib.mkIf hostConfig.isLaptop true;

  # ── Throne ────────────────────────────────────────────────────────────────
  programs.throne = {
    enable         = true;
    tunMode.enable = true;
  };

  # ── fish ──────────────────────────────────────────────────────────────────
  programs.fish.enable = true;

  # ── niri ──────────────────────────────────────────────────────────────────
  programs.niri.enable = true;

  # ── Nix ───────────────────────────────────────────────────────────────────
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
      animation = "doom";
      bigclock  = true;
    };
  };

  # ── SSH ───────────────────────────────────────────────────────────────────
  services.openssh.enable = true;
  services.openssh.ports  = [ 2222 ];

  # ── Прочее ────────────────────────────────────────────────────────────────
  security.polkit.enable    = true;
  hardware.bluetooth.enable = true;

  system.stateVersion = "25.11";
}
