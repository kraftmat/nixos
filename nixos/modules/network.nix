{ ... }:

{
  networking.networkmanager.enable = true;
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
  };

  # ── SSH ───────────────────────────────────────────────────────────────────
  services.openssh.enable = true;
  services.openssh.ports = [ 2222 ];
}
