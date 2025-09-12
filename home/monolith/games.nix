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

  # https://nixos.wiki/wiki/Android
  programs.adb.enable = true;

  # Epic in Lutris
  hardware.graphics.enable32Bit = true;

  # VR headset support
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
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
