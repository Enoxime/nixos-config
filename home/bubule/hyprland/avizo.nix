_: {
  # https://github.com/heyjuvi/avizo (for the sound and brightness notification)
  # Neat notification daemon for Wayland
  services.avizo = {
    enable = true;
    settings = {
      default = {
        background = "rgba(128, 135, 162, 1)";
        time = 2;
      };
    };
  };
}
