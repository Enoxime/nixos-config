{ pkgs, inputs, username, ... }: {
  home.packages = with pkgs; [
    protonup-ng
    sidequest
    inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.star-citizen
    # VR headset support
    opencomposite
    wayvr
  ];

  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/${username}/.steam/root/compatibilitytools.d";
  };

  # https://nixos.wiki/wiki/Lutris
  programs.lutris = {
    enable = true;
    extraPackages = with pkgs; [
      mangohud
      winetricks
      gamescope
      gamemode
      umu-launcher
    ];
    protonPackages = [ pkgs.proton-ge-bin ];
  };

  # VR headset support
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };
}
