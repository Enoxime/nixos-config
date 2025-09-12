{ pkgs, config, ... }: {
  sops.secrets.ca_url = {
    sopsFile = ../../../secrets/secrets.yaml;
  };

  # TODO
  # services.clamav = {
  #   daemon.enable = ;
  #   fangfrisch = {
  #     enable = ;
  #     interval = "daily";
  #   };
  #   updater = {
  #     enable = ;
  #     interval = "daily"; #man systemd.time
  #     frequency = 12;
  #   };
  # };

  security.pki.certificateFiles = [
    (pkgs.fetchurl {
      url = "${config.sops.secrets.ca_url.path}/roots.pem";
      name = "homelab.crt";
      hash = "sha256-5mZoCAUuvVHhLYxl3Lol05tqOH32Rly1e7FTSRTIvas=";
      curlOpts = "--insecure";
    })
  ];
}
