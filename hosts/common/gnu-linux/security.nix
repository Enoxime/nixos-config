{ pkgs, config, ... }: {
  sops.secrets."homelab/ca" = {
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

  security.pki.certificates = [
    "${config.sops.secrets."homelab/ca".path}"
  ];
}
