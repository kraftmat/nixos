{ ... }:

{
  imports = [ ./zapret.nix ];

  services.yggdrasil = {
    enable = true;
    persistentKeys = true;
    settings = {
      Peers = [
    "tls://ygg1.mk16.de:1338?key=0000000087ee9949eeab56bd430ee8f324cad55abf3993ed9b9be63ce693e18a"
    "tls://reticulum.me:12393?key=a3d411280dfc350a4484aa3da5feb0407518c5820cbb011d5620347769b26665"
    "tls://yggdrasil.sunsung.fun:4443"
    "ws://dc.txlyre.website:13370"
    "ws://waw01.yggdrasil.hosted-by.skhron.eu:8886?key=030602cee88a761c68f5f14e1dad430f25238a703b69dc382321a38f833035b0"
    "tcp://kem.txlyre.website:1337"
    "tcp://mskaeza.i113d.ru:12631"
    "tls://yg-vvo.magicum.net:29331"
    "tls://ygg1.mk16.de:1338?key=0000000087ee9949eeab56bd430ee8f324cad55abf3993ed9b9be63ce693e18a"
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
