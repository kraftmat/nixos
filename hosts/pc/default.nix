{ pkgs, hostName, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = hostName;
  networking.interfaces.enp3s0.wakeOnLan.enable = true;

  # ── Ядро ────────────────────────────────────────────────────────────
  boot.kernelParams = [ "amd_pstate=active" "amdgpu.ppfeaturemask=0xffffffff" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  hardware.cpu.amd.updateMicrocode = true;
  hardware.cpu.intel.updateMicrocode = false;

  # ── Графика ───────────────────────────────────────────────────────────────
  services.xserver.videoDrivers = [ "amdgpu" ];

  # LACT
  systemd.services.lact = {
    description = "AMDGPU Control Daemon";
    enable = true;
    serviceConfig = {
      ExecStart = "${pkgs.lact}/bin/lact daemon";
    };
    wantedBy = [ "multi-user.target" ];
  };

  # ── Home Manager ─────────────────────────────────
  home-manager.extraSpecialArgs.hostConfig = {
    enableLact = true;
    isLaptop = false;
    monitor = "DP-1";
    mode = "1920x1080@144";
  };
  home-manager.users.kraftmat = {
    home.packages = with pkgs; [ lact llama-cpp-vulkan ];
    home.stateVersion = "26.05";
  };

  system.stateVersion = "26.05";
}
