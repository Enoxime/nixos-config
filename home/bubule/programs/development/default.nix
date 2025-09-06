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
    pipenv
    pkg-config
    nodejs # Needed for pre-commit for whatever reasons
    readline
    shellcheck
    waydroid
    zlib
  ];
}
