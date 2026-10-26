{ config, pkgs, hostName, ... }:

{
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      pixel-art
      obs-retro-effects
    ];
  };

  programs.micro = {
    enable = true;
    settings = {
      clipboard = "terminal";
      colorscheme = "solarized";
      hlsearch = true;
      lsp = true;
      filemanager = true;
    };
  };

  home.activation.installMicroLsp = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD ${pkgs.micro}/bin/micro -plugin install lsp || true
    $DRY_RUN_CMD ${pkgs.micro}/bin/micro -plugin install filemanager || true
  '';

  # ── EasyEffects ───────────────────────────────────────────────────────────
  services.easyeffects.enable = true;

  # ── Discord (equibop) ─────────────────────────────────────────────────────
  programs.equibop = {
    enable = true;
    settings = {
      arRPC = true;
      checkUpdates = true;
      customTitleBar = false;
      disableMinSize = true;
      minimizeToTray = true;
      tray = true;
      splashTheming = true;
      staticTitle = true;
      hardwareAcceleration = true;
      discordBranch = "сanary";
    };
    equicord = {
      extraQuickCss = builtins.readFile ./cfg/dank-discord.css;
      settings = {
        notifyAboutUpdates = false;
        useQuickCss = true;
        plugins = {
          FakeNitro.enabled = true;
          QuickReply.enabled = true;
          NoBlockedMessages.enabled = true;
          BlurNSFW.enabled = true;
          NoMiddleClickPaste.enabled = true;
          NoPushToTalk.enabled = true;
          NoReplyMention.enabled = true;
          ServerInfo.enabled = true;
          Timezones.enabled = true;
          ShowHiddenChannels.enabled = true;
          ReadAllNotificationsButton.enabled = true;
          MessageLogger = {
            enabled = true;
            ignoreSelf = true;
          };
        };
      };
    };
  };

  # ── nixMonitor plugin config ──────────────────────────────────────────────
  xdg.configFile."DankMaterialShell/plugins/NixMonitor/config.json".text = builtins.toJSON {
    generationsCommand = [ "sh" "-c" "ls -d /nix/var/nix/profiles/system-*-link 2>/dev/null | wc -l" ];
    storeSizeCommand = [ "sh" "-c" "sudo -n /run/current-system/sw/bin/compsize /nix/store 2>/dev/null | awk '$1==\"TOTAL\"{print $3}'" ];
    rebuildCommand = [ "bash" "-c" "sudo nixos-rebuild switch --flake /etc/nixos#${hostName} 2>&1" ];
    gcCommand = [ "sh" "-c" "nix-collect-garbage -d 2>&1" ];
    updateInterval = 3600;
  };
}
