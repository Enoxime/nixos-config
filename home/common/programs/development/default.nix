{ pkgs, ... }: {
  home.packages = with pkgs; [
    amber-lang
    # bshchk
    # topf
    (callPackage ../../../../pkgs/topf.nix {})
    pipenv
    nodejs # Needed for pre-commit for whatever reasons
    shellcheck
    shfmt
    uv
    # topf dependency
    vals
  ];
}
