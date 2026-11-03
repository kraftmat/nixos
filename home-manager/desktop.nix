{ pkgs, ... }:

{
  xdg.enable = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "org.gnome.Nautilus.desktop";
    };
  };


  dconf.settings = {
    "org/gnome/nautilus/preferences" = {
      show-image-thumbnails = "always";
    };
  };

  # ── Cursor не ии ────────────────────────────────────────────────────────────────
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  services.easyeffects.enable = true;
}
