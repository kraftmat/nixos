{ config, lib, pkgs, hostName, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = hostName;

  services.zapret-home = {
    enable    = true;
    interface = "wlo1";
  };

  # ── Ядро ────────────────────────────────────────────────────────────
  boot.kernelParams = [ "intel_pstate=active" "nvidia.NVreg_DynamicPowerManagement=0x02" ];
  boot.initrd.kernelModules = [ "i915" ];
  hardware.cpu.intel.updateMicrocode = true;
  hardware.cpu.amd.updateMicrocode = false;
  boot.kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_xanmod; #дрова нвиди фигня,не робят с 7.2

  # ── Графика ──────────────────────────────────────
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    libva-vdpau-driver
    libvdpau-va-gl
  ];

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
    WLR_DRM_DEVICES = "/dev/dri/card1";
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement = {
      enable = true;
      finegrained = true;
    };
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # ── Питание ───────────────────────────────────────────────────────────────
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # ── Home Manager ─────────────────────────────────
  home-manager.extraSpecialArgs.hostConfig = {
    enableLact = false;
    isLaptop = true;
    monitor = "eDP-1";
    mode = "1920x1080@165";
  };
  home-manager.users.kraftmat = {
    home.stateVersion = "26.05";
  };

  system.stateVersion = "26.05";
}
