{config, ...}: {
  sops.secrets.timezone = {
    sopsFile = ../../secrets/secrets.yaml;
  };

  # Set your time zone.
  time = {
    hardwareClockInLocalTime = true;
    timeZone = "${config.sops.secrets.timezone.path}";
  }; 
}
