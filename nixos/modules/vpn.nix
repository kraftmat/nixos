{ ... }:

{
  imports = [ ./zapret.nix ];

  services.yggdrasil = {
    enable = true;
    settings = {
      Peers = [
        "tls://45.95.202.21:443"
        "tls://45.147.200.202:443"
        "tls://yg-vvo.magicum.net:29331"
        "tls://ygg1.mk16.de:1338?key=0000000087ee9949eeab56bd430ee8f324cad55abf3993ed9b9be63ce693e18a"
        "tls://ygg2.mk16.de:1338?key=000000d80a2d7b3126ea65c8c08fc751088c491a5cdd47eff11c86fa1e4644ae"
        "tls://reticulum.me:12393?key=a3d411280dfc350a4484aa3da5feb0407518c5820cbb011d5620347769b26665"
      ];
      MulticastInterfaces = [ ];
    };
  };

  services.cloudflare-warp.enable = true;

  services.zerotierone = {
    enable = true;
    joinNetworks = [
      "b9a18a606ffecb53"
    ];
  };

  # ── Throne ────────────────────────────────────────────────────────────────
  programs.throne = {
    enable = true;
    tunMode.enable = true;
  };
}
