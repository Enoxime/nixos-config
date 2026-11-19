{ config, username, ... }: {
  sops.secrets."wireguard/homelab" = {
    mode = "0440";
    owner = "${username}";
    group = "${username}";
  };

  # Keep the main network from handing eno1 a global IPv6 via router
  # advertisements (pure kernel autoconf — dhcpcd/NM are not involved here).
  boot.kernel.sysctl."net.ipv6.conf.eno1.accept_ra" = 0;

  networking = {
    # hosts = {
    #   "127.0.0.1" = ["garage.garage"];
    # };

    # NM must not manage the VLAN parent: leave eno1 unaddressed but link-up.
    # Per-interface useDHCP only governs the dhcpcd/networkd backends; with NM
    # enabled, NixOS sets global useDHCP=false and NM was handing eno1 an IPv4
    # lease via its auto-connected "Wired connection" profile instead.
    networkmanager.unmanaged = [ "eno1" ];

    vlans.vlan50 = {
      interface = "eno1";
      id = 50;
    };

    interfaces = {
      vlan50.useDHCP = true;
      eno1.useDHCP = false;
    };

    # vpn
    wg-quick.interfaces.homelab-mgmt = {
      autostart = false;
      configFile = config.sops.secrets."wireguard/homelab".path;
    };

    bridges = {
      externalbr0 = {
        interfaces = ["wlan0"];
      };
    };
  };
}
