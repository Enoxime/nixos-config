_: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };

    taps = [
      "homebrew/cask"
      "homebrew/core"
      "nrlquaker/createzap"
    ];

    masApps = {
      # "keeper" = "1231242r";
      Xcode = 497799835;
      "Yubico Authenticator" = 1497506650;
    };

    casks = [
      {
        name = "librewolf";
        args = { "no-quarantine" = ""; };
      }
    ];
  };
}
