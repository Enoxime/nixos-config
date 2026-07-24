{ pkgs, ...}: {
  # Virtualization / Containers
  virtualisation = {
    # https://wiki.nixos.org/wiki/Docker
    docker = {
      enable = true;
      storageDriver = "btrfs";
    };

    # https://wiki.nixos.org/wiki/Incus
    incus = {
      enable = true;
      agent.enable = true;
      preseed = {
        networks = [
          {
            name = "incusbr0";
            type = "bridge";
            description = "Internal/NATted bridge";
            config = {
              "ipv4.address" = "auto";
              "ipv4.nat" = "true";
              "ipv4.firewall" = "false";
              "ipv6.address" = "auto";
              "ipv6.nat" = "true";
              "ipv6.firewall" = "false";
            };
          }
        ];
        profiles = [
          {
            name = "default";
            description = "Default Incus Profile";

            devices = {
              eth0 = {
                name = "eth0";
                network = "incusbr0";
                type = "nic";
              };

              root = {
                path = "/";
                pool = "default";
                type = "disk";
              };
            };
          }

          # {
          #   name = "bridged";
          #   description = "Instances bridged to LAN";

          #   devices = {
          #     eth0 = {
          #       name = "eth0";
          #       nictype = "bridged";
          #       parent = "externalbr0";
          #       type = "nic";
          #     };

          #     root = {
          #       path = "/";
          #       pool = "default";
          #       type = "disk";
          #     };
          #   };
          # }
        ];
        storage_pools = [
          {
            config = {
              source = "/var/lib/incus/storage-pools/default";
            };
            driver = "dir";
            name = "default";
          }
        ];
      };
      ui.enable = true;
    };

    libvirtd = {
      enable = true;

      qemu = {
        # Enable TPM emulation (optional)
        swtpm.enable = true;
      };
    };

    # Enable USB redirection (optional)
    spiceUSBRedirection.enable = true;

    # https://nixos.wiki/wiki/Podman
    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = false;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  environment.systemPackages = with pkgs; [
    qemu
    spice
    spice-protocol
  ];

  # https://wiki.nixos.org/wiki/QEMU
  systemd.tmpfiles.rules = [ "L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware" ];
}
