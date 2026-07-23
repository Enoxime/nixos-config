_: {
  wayland.windowManager.hyprland.extraLuaFiles = {
    "monitors" = {
      content = ''
        hl.monitor({
          output = "DP-1",
          mode = "5120x1440@120",
          position = "0x0",
          scale = "1",
        })
        hl.monitor({
          output = "DP-2",
          mode = "preferred",
          position = "5120x0",
          scale = "1",
        })
      '';
      autoLoad = true;
    };

    "extraEnv" = {
      content = ''
        hl.env("LIBVA_DRIVER_NAME", "nvidia")
        hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
      '';
      autoLoad = true;
    };
  };
}
