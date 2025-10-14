{ pkgs, ... }: {
  imports = [
    ./vscodium.nix
  ];

  # Nice reference: https://github.com/the-nix-way/dev-templates/tree/main

  home.packages = with pkgs; [
    binutils
    bzip2
    gcc
    gnumake
    gnutar
    libffi
    ncurses
    openssl
    pkg-config
    readline
    waydroid
    zlib
  ];
}
