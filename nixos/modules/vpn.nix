{ ... }:

{
  imports = [ ./zapret.nix ];

  services.yggdrasil = {
    enable = true;
    persistentKeys = true;
    settings = {
      Peers = [
	tls://mskaeza.i113d.ru:12632
	tls://ralsei.ru:12345
	tls://yg-vvo.magicum.net:29331
	tls://cm1.wwire.su:2231
	tls://mskaeza.i113d.ru:12632
     ];
      MulticastInterfaces = [ ];
    };
  };
  services.yggdrasil-jumper = {
  	enable = true;
  	detectWireguard = true; 
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
