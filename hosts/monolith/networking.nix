{ config, username, ... }: {
  sops.secrets."wireguard/homelab" = {
    mode = "0440";
    owner = "${username}";
    group = "${username}";
  };

  networking = {
    hosts = {
      "127.0.0.1" = ["garage.garage"];
    };

    # networkmanager.ensureProfiles.profiles = {};

    # vpn
    wg-quick.interfaces.homelab-mgmt = {
      autostart = false;
      configFile = config.sops.secrets."wireguard/homelab".path;
    };
  };
}
