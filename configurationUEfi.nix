{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # ── Загрузчик ─────────────────────────────────────────────────────────────
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.efi.canTouchEfiVariables = true;

  # ── Сеть ──────────────────────────────────────────────────────────────────
  networking.hostName = "kraftmat-pc";
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 2222 ];

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
  ];

  # ── Nix ───────────────────────────────────────────────────────────────────
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ── Звук ──────────────────────────────────────────────────────────────────
  services.pipewire = {
    enable            = true;
    alsa.enable       = true;
    pulse.enable      = true;
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
