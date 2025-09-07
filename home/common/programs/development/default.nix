{ pkgs, ... }: {
  imports = [
    ./vscodium.nix
  ];
  
  home.packages = with pkgs; [
    pipenv
    nodejs # Needed for pre-commit for whatever reasons
    shellcheck
  ];
}
