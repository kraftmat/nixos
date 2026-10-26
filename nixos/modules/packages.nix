{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    micro
    git
    wget
    fastfetch
    nftables
    procps
    screen
    ffmpeg
    nixd
    nixfmt
    statix
    cloudflare-warp
    cloudflared
    compsize
    valent
    docker-compose
    pulseaudio
  ];

  programs.nano.enable = false;

  fonts.packages = with pkgs; [
    inter-nerdfont
  ];
}
