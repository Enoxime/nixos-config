{ pkgs, ...}: {
  # Virtualization / Containers
  virtualisation = {
    # https://wiki.nixos.org/wiki/Docker
    docker = {
      enable = true;
      storageDriver = "btrfs";
    };

    # https://wiki.nixos.org/wiki/Incus
    incus.enable = true;

    libvirtd = {
      enable = true;

      qemu = {
        # Enable TPM emulation (optional)
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [ pkgs.OVMFFull.fd ];
        };
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
