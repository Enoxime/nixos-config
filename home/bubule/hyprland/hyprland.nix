_: {
  wayland.windowManager.hyprland.extraLuaFiles = {
    "monitors" = {
      content = ''
        hl.monitor({
          output = "eDP-1",
          mode = "1920x1200@165.00Hz",
          position = "auto",
          scale = "1",
        })
      '';
      autoLoad = true;
    };
  };
}
