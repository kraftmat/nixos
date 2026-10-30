{ pkgs, lib, config, ... }:

let
  cfg = config.services.zapret-home;
  zapretSrc = pkgs.fetchFromGitHub {
    owner = "Sergeydigl3";
    repo  = "zapret-discord-youtube-linux";
    rev   = "69db771b527ba11ca71efe28728a7f9491eec352";
    hash  = "sha256-UmsoF5YejczR87iv1fGU9LA4JXDz714dhop/Q4sMCBQ=";
  };
in
{
  options.services.zapret-home = {
    enable        = lib.mkEnableOption "zapret-home";
    interface     = lib.mkOption { type = lib.types.str;  default = "eth0"; };
    strategy      = lib.mkOption { type = lib.types.str;  default = "general.bat"; };
    gamefiltertcp = lib.mkOption { type = lib.types.bool; default = true; };
    gamefilterudp = lib.mkOption { type = lib.types.bool; default = true; };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.zapret-home = {
      description = "Zapret";
      after       = [ "network.target" ];
      wantedBy    = [ "multi-user.target" ];
      path        = with pkgs; [ git gnutar gzip iptables nftables gawk procps curl coreutils gnused gnugrep bash ];
      serviceConfig = {
        Type             = "simple";
        User             = "root";
        StateDirectory   = "zapret";
        WorkingDirectory = "/var/lib/zapret";
        ExecStartPre     = pkgs.writeShellScript "zapret-init" ''
          set -e
          cd /var/lib/zapret
          if [ ! -f service.sh ]; then
            cp -r ${zapretSrc}/. .
            chmod -R u+w .
          fi
          cat > conf.env << EOF
strategy=${cfg.strategy}
interface=${cfg.interface}
gamefiltertcp=${if cfg.gamefiltertcp then "true" else "false"}
gamefilterudp=${if cfg.gamefilterudp then "true" else "false"}
EOF
          if [ "$(cat .deps-rev 2>/dev/null)" != "${zapretSrc.rev}" ]; then
            bash service.sh download-deps --default
            echo "${zapretSrc.rev}" > .deps-rev
          fi
        '';
        ExecStart  = "${pkgs.bash}/bin/bash /var/lib/zapret/service.sh daemon";
        Restart    = "on-failure";
        RestartSec = "5s";
      };
    };
  };
}
