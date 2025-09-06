{ pkgs, ... }: {
  # Automaticly change the screen temperature depending of the sun position
  services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = 45.5;
    longitude = -73.5;
    temperature = {
      day = 5500;
      night = 3700;
    };
    tray = false;
  };
}
