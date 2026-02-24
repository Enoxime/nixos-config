_: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };

    taps = [
      # "homebrew/cask"
      # "homebrew/core"
      "nrlquaker/createzap"
    ];

    masApps = {
      # "Yubico Authenticator" = 1497506650;
    };

    casks = [
      {
        name = "librewolf";
        args = { "no_quarantine" = true; };
      }
      "iterm2"
      "ghostty"
    ];

    brews = [
      "minikube"
    ];
  };
}
