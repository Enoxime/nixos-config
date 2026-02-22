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
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
      gamescopeSession.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    # https://nixos.wiki/wiki/Android
    android-tools
    bottles
    (heroic.override {
      extraPkgs = pkgs: [
        pkgs.gamescope
        pkgs.gamemode
      ];
    })
    # itch # itch.io
    mangohud
    protonup-qt
    # support both 32-bit and 64-bit applications
    wineWow64Packages.stable
    # native wayland support (unstable)
    # wineWow64Packages.waylandFull
  ];

  hardware = {
    # support for the xbox controller USB dongle
    xone.enable = true;
    # Epic in Lutris
    graphics.enable32Bit = true;
  };

  # https://wiki.nixos.org/wiki/VR#WiVRn
  services.wivrn = {
    enable = true;
    openFirewall = true;

    # Write information to /etc/xdg/openxr/1/active_runtime.json, VR applications
    # will automatically read this and work with WiVRn (Note: This does not currently
    # apply for games run in Valve's Proton)
    defaultRuntime = true;

    # Run WiVRn as a systemd service on startup
    autoStart = true;

    # note for steam command:
    # Like Monado, you will also have to add the launch argument for WiVRn to
    # allow access to the socket:
    # PRESSURE_VESSEL_FILESYSTEMS_RW=$XDG_RUNTIME_DIR/wivrn/comp_ipc %command%
  };
}
