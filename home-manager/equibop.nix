{ ... }:

{
  programs.equibop = {
    enable = true;
    settings = {
      arRPC                = true;
      checkUpdates         = true;
      customTitleBar       = false;
      disableMinSize       = true;
      minimizeToTray       = true;
      tray                 = true;
      splashTheming        = true;
      staticTitle          = true;
      hardwareAcceleration = true;
      discordBranch        = "canary";
    };
    equicord = {
      extraQuickCss = builtins.readFile ./cfg/dank-discord.css;
      settings = {
        notifyAboutUpdates = false;
        useQuickCss        = true;
        plugins = {
          FakeNitro.enabled              = true;
          QuickReply.enabled             = true;
          NoBlockedMessages.enabled      = true;
          BlurNSFW.enabled               = true;
          NoMiddleClickPaste.enabled     = true;
          NoPushToTalk.enabled           = true;
          NoReplyMention.enabled         = true;
          ServerInfo.enabled             = true;
          Timezones.enabled              = true;
          ShowHiddenChannels.enabled     = true;
          ReadAllNotificationsButton.enabled = true;
          MessageLogger = {
            enabled    = true;
            ignoreSelf = true;
          };
        };
      };
    };
  };
}
