{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # ── Загрузчик ─────────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable      = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint     = "/boot";

  # ── Файловая система ───────────────────────────────────────────────────────
  boot.supportedFilesystems = [ "btrfs" ];

  # ── Ядро / AMD ────────────────────────────────────────────────────────────
  boot.kernelParams = [ "amd_pstate=active" ];
  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware.cpu.amd.updateMicrocode = true;

  hardware.graphics = {
    enable      = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "amdgpu" ];

  # ── Zram ──────────────────────────────────────────────────────────────────
  zramSwap = {
    enable    = true;
    algorithm = "zstd";
  };

  # ── Сеть ──────────────────────────────────────────────────────────────────
  networking.hostName = "kraftmat-pc";
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 2222 ];
  services.yggdrasil = {
    enable = true;
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

  # ── Локаль / время ────────────────────────────────────────────────────────
  time.timeZone = "Europe/Riga";
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
  ];

  
  # ── Throne ───────────────────────────────────────────────────────────────────
  programs.throne = {
    enable = true;
    tunMode.enable = true;
  };
  
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

  # ── Wayland / niri ────────────────────────────────────────────────────────
  programs.niri.enable = true;

  xdg.portal = {
    enable        = true;
    extraPortals  = [ pkgs.xdg-desktop-portal-gnome ];
    config.common.default = "gnome";
  };

  # ── Display manager ───────────────────────────────────────────────────────
  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "doom";
      bigclock  = true;
    };
  };

  # ── Fish ──────────────────────────────────────────────────────────────────
  programs.fish.enable = true;

  # ── SSH ───────────────────────────────────────────────────────────────────
  services.openssh.enable = true;
  services.openssh.ports  = [ 2222 ];

  # ── Прочее ────────────────────────────────────────────────────────────────
  security.polkit.enable    = true;
  hardware.bluetooth.enable = true;

  system.stateVersion = "25.11";
}
