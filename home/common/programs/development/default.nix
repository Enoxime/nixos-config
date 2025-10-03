{ pkgs, lib, ... }: {
  imports = [
    ./vscodium.nix
  ];

  home.packages = with pkgs; [
    amber-lang
    # bshchk
    (callPackage ../../../../pkgs/bshchk.nix {})
    pipenv
    nodejs # Needed for pre-commit for whatever reasons
    shellcheck
    shfmt
  ];
}
