_: {
  # sops.secrets.timezone = {
  #   sopsFile = ../../../secrets/secrets.yaml;
  # };

  # Set your time zone.
  time = {
    hardwareClockInLocalTime = false;
    # timeZone = "${config.sops.secrets.timezone.path}";
    timeZone = "America/New_York";
  };

  services.ntp = {
    enable = true;
    servers = [
      "2.pool.ntp.org" # IPv6 support
    ];
  };
}
