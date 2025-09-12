_: {
  services = {
    btrfs.autoScrub = {
      enable = true;
      interval = "weekly";
      fileSystems = [ "/" ];
    };

    # BTRFS deduplication clean
    # See https://github.com/Zygo/bees/blob/master/docs/config.md
    beesd.filesystems = {
      "@root" = {
        spec = "LABEL=system";
        hashTableSizeMB = 128;
        verbosity = "crit";
        extraOptions = [ "--loadavg-target" "5.0" ];
      };
    };

    fstrim = {
      enable = true;
      interval = "weekly";
    };

    udev.enable = true;
    dbus.enable = true;

    # Enable autodiscovery of network printers
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    rpcbind.enable = true; # needed for NFS
  };
}
