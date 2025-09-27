{
  lib,
  pkgs,
  hostname,
  config,
  ...
}: {
  sops.secrets.timezone = {
    sopsFile = ../../secrets/secrets.yaml;
  };

  nix = {
    gc = {
      automatic = true;
      interval = [{ Weekday = 7; }];
      options = "--delete-older-than 7d";
    };

    settings = {
      # https://github.com/NixOS/nix/issues/7273
      auto-optimise-store = false;
    };
  };

  # Don't need channels since I use flakes
  nix.channel.enable = false;

  # Fonts
  fonts.packages = with pkgs; [
    recursive
    nerd-fonts.jetbrains-mono
  ];

  environment = {
    variables = {
      EDITOR = "vim";
    };

    shells = with pkgs; [
      bashInteractive
      zsh
    ];
  };

  programs = {
    bash.enable = true;
    # Direnv, load and unload environment variables depending on the current directory.
    # https://direnv.net
    # https://rycee.gitlab.io/home-manager/options.html#opt-programs.direnv.enable
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    gnupg.agent.enable = true;
    man.enable = true;
    vim.enable = true;
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableBashCompletion = true;
      enableCompletion = true;
      enableSyntaxHighlighting = true;
      shellInit = ''
        # krew
        export PATH="''${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

        # Pipenv auto source (pipenv shell)
        function auto_pipenv_shell {
          if [ ! -n "''${PIPENV_ACTIVE+1}" ]; then
            if [ -f "Pipfile" ] ; then
              pipenv shell
            fi
          fi
        }

        function cd {
          builtin cd "$@"
          auto_pipenv_shell
        }

        auto_pipenv_shell
      '';
    };
  };

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  networking = {
    applicationFirewall = {
      allowSigned = true;
      allowSignedApp = true;
      blockAllIncoming = false;
      enable = true;
      enableStealthMode = true;
    };
    computerName = "${hostname}";
    dns = [
      "9.9.9.9"
      "149.112.112.112"
      "2620:fe::fe"
      "2620:fe::9"
    ];
    hostName = "${hostname}";
    knownNetworkServices = [
      "Wi-Fi"
      "Thunderbolt Bridge"
    ];
    localHostName = "${hostname}";
  };

  time.timeZone = "${config.sops.secrets.timezone.path}";

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = 1; # Did you read the comment?
}
