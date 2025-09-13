{ pkgs, inputs, ... }: {
  home.packages = with pkgs; [
    protonup
    sidequest
    inputs.nix-gaming.packages.${pkgs.system}.star-citizen

    # VR headset support
    opencomposite
    wlx-overlay-s
  ];

  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\\\${HOME}/.steam/root/compatibilitytools.d";
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
