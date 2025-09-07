_: {
  system.defaults = {
    controlcenter = {
      BatteryShowPercentage = true;
      Bluetooth = true;
      FocusModes = true;
    };
    # dock = {
    #   # https://mynixos.com/nix-darwin/options/system.defaults.dock.persistent-apps.*
    # };
    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "Nlsv";
      FXRemoveOldTrashItems = true;
      NewWindowTarget = "Home";
      ShowExternalHardDrivesOnDesktop = true;
      ShowHardDrivesOnDesktop = true;
      ShowMountedServersOnDesktop = true;
      ShowPathbar = true;
      ShowRemovableMediaOnDesktop = true;
      ShowStatusBar = true;
    };
    iCal = {
      "first day of week" = "Monday";
      "TimeZone support enabled" = true;
    };
    loginwindow = {
      autoLoginUser = "Off";
      DisableConsoleAccess = true;
      GuestEnabled = false;
    };
    menuExtraClock = {
      Show24Hour = true;
      ShowAMPM = false;
      ShowDate = 1;
    };
    NSGlobalDomain = {
      AppleICUForce24HourTime = true;
      AppleInterfaceStyle = "Dark";
      AppleMeasurementUnits = "Centimeters";
      AppleMetricUnits = 1;
      AppleShowAllFiles = true;
      AppleTemperatureUnit = "Celsius";
      NSDocumentSaveNewDocumentsToCloud = false;
    };
    screensaver.askForPassword = true;
    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;
    spaces.spans-displays = true;
    trackpad = {
      ActuationStrength = 0;
      Clicking = true;
      TrackpadRightClick = true;
      TrackpadThreeFingerDrag = true;
    };
  };
}
