{ pkgs, ... }: {
  imports = [
    ./devops
    ./development
    ./shell.nix
    ./ssh.nix
  ];

  programs = {
    awscli.enable = true;
    bat.enable = true;
    gpg.enable = true;
    # A lightweight and flexible command-line JSON processor
    jq.enable = true;
    lsd.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
    yt-dlp.enable = true;
  };

  home.packages = with pkgs; [
    # archives
    zip
    xz
    unzip
    p7zip
    gnutar
    lz4

    # networking tools
    # ipcalc  # it is a calculator for the IPv4/v6 addresses

    # security/encrypt
    sops
    age
  ];
}
