{ config, pkgs, ... }:

{
  # ── Загрузчик ─────────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable = false; # сустемд вирусня
  boot.loader.limine.enable = true;
  boot.loader.limine.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.limine.style.wallpapers = [ ../../wallpapers/7.jpg ];

  # ── Файловая система ──────────────────────────────────────────────────────
  boot.supportedFilesystems = [ "btrfs" ];
  services.fstrim.enable = true;

  # ── Ядро ──────────────────────────────────────────────────────────────────
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_stable;
  # kernelParams и initrd.kernelModules задаются в hosts/<имя>/
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';

  # ── Zram ──────────────────────────────────────────────────────────────────
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };
}
