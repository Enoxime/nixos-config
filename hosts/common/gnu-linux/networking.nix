{ pkgs, hostname, ... }: {
  networking = {
    hostName = "${hostname}";
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };

    # wireless.iwd = {
    #   enable = true;
    #   settings = {
    #     Network = {
    #       EnableIPv6 = true;
    #     };
    #   };
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

  };

  environment.systemPackages = with pkgs; [
    iwd
  ];
}
