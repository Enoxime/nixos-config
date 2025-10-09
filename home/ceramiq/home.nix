{ username, hostname, config, ... }: {
  imports = [
    ./git.nix
    ./programs.nix
    ./shell.nix
  ];

  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/${hostname}/secrets.yaml;
  };

  # Catppuccin theme
  # https://nix.catppuccin.com/
  # https://nix.catppuccin.com/search/rolling/
  catppuccin = {
    enable = true;
    # flavor = "macchiato";
    flavor = "mocha";
  };

  home = {
    username = "${username}";
    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
