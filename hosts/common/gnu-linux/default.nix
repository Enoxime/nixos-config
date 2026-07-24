{ pkgs, ... }: {
  imports = [
    ./greeter.nix
    ./locales.nix
    ./networking.nix
    ./security.nix
    ./services.nix
    ./sound.nix
    ./time.nix
    ./users.nix
    ./virtualisation.nix
  ];

  environment.pathsToLink = [ "/share/xdg-desktop-portal" "/share/applications" ];

  environment.systemPackages = [
    # https://nixos.wiki/wiki/Android
    pkgs.android-tools
  ];
}
