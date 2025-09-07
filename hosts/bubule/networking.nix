{ pkgs, config, username, hostname, ... }: {
  sops.secrets."wireguard/homelab" = {
    mode = "0440";
    owner = "${username}";
    group = "${username}";
  };

  networking = {
    hostName = "${hostname}";
    hosts = {
      "127.0.0.1" = ["garage.garage"];
    };
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };

    # wireless.iwd = {
    #   enable = true;
    # };

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    firewall.enable = true;
    nftables.enable = true;

    # This config does not exists
    # dhcpd = {
    #   # no need to wait interfaces to have an IP to continue booting
    #   wait = "background";
    #   # avoid checking if IP is already taken to boot a few seconds faster
    #   extraConfig = "noarp";

    #   persistent = true;
    # };

    enableIPv6 = true;

    # vpn
    wg-quick.interfaces.homelab-mgmt = {
      autostart = false;
      configFile = config.sops.secrets."wireguard/homelab".path;
    };
  };

  environment.systemPackages = with pkgs; [
    iwd
  ];
}
