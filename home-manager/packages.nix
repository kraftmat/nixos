{ pkgs, pkgs-unstable, inputs, yapfast, ... }:

{
  home.packages = with pkgs; [
    xwayland-satellite
    wl-clipboard
    brightnessctl
    pwvucontrol
    libinput
    playerctl
    cliphist
    btop
    nautilus
    showtime
    loupe
    bibata-cursors
    morewaita-icon-theme
    gh
    protonup-qt
    mangohud
    floorp-bin
    gvfs
    nerd-fonts.jetbrains-mono
    inter-nerdfont
    qbittorrent
    wineWow64Packages.stable
    materialgram
    thunderbird
    adw-gtk3
    (inputs.fjordlauncher.packages.${pkgs.stdenv.hostPlatform.system}.fjordlauncher.override {
      jdks = with pkgs; [ zulu zulu21 zulu17 temurin-bin-17 zulu8 zulu25 ];
    })
    lua
    inter
    go
    gamescope
    pkgs-unstable.strawberry
    compsize
    valent
    pkgs-unstable.opencode
    yapfast.packages.${pkgs.system}.yapfast
    mumble
    pkgs-unstable.antigravity-ide
  ];
}
