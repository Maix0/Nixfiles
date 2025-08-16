{
  zen-browser,
  pkgs,
  myPkgs,
  ...
}: {
  imports = [
    zen-browser.homeModules.twilight
  ];

  home.packages = [
    pkgs.firefoxpwa
    myPkgs.bitwarden-desktop
  ];
  programs.zen-browser = {
    enable = true;
    nativeMessagingHosts = [
      pkgs.bitwarden-desktop
      pkgs.firefoxpwa
    ];
    policies = {
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      Preferences = {
        "browser.tabs.warnOnClose" = {
          "Value" = false;
          "Status" = "locked";
        };
      };
    };
  };
}
