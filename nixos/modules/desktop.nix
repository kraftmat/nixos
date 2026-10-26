{ pkgs, ... }:

{
  # ── niri ──────────────────────────────────────────────────────────────────
  programs.niri.enable = true;
  systemd.user.services.niri-flake-polkit.enable = false;

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    config.common.default = "gnome";
  };

  security.polkit.enable = true;
  services.gvfs.enable = true;

  # ── Display manager ───────────────────────────────────────────────────────
  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "dur_file";
      dur_file_path = "${../../assets/blackhole-smooth-240x67.dur}";
      full_color = true;
      bigclock = true;
    };
  };
}
