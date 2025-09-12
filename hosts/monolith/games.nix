{ pkgs, lib, ... }: {
  # Resources:
  # https://nixos.wiki/wiki/Steam
  # https://nixos.wiki/wiki/Games
  # https://wiki.nixos.org/wiki/GameMode

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-unwrapped"
    "steam-run"
  ];

  programs = {
    gamescope = {
      enable = true;
      capSysNice = true;
    };
    gamemode.enable = true;
  };

  environment.systemPackages = with pkgs; [
    bottles
    (heroic.override {
      extraPkgs = pkgs: [
        pkgs.gamescope
        pkgs.gamemode
      ];
    })
    itch # itch.io
    mangohud
    protonup-qt
    # support both 32-bit and 64-bit applications
    wineWowPackages.stable
    # native wayland support (unstable)
    # wineWowPackages.waylandFull
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    gamescopeSession.enable = true;
  };

  hardware.xone.enable = true; # support for the xbox controller USB dongle

  # VR headset
  programs.alvr = {
    enable = true;
    openFirewall = true;
  };
}
