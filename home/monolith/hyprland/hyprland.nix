_: {
  wayland.windowManager.hyprland.settings = {
    monitor = [
      "DP-1, 5120x1440@120, 0x0, 1"
      "DP-2, preferred, 5120x0, 1"
    ];

    env = [
      "LIBVA_DRIVER_NAME,nvidia"
      "__GLX_VENDOR_LIBRARY_NAME,nvidia"
    ];
  };
}
