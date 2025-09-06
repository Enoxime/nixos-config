_: {
  fileSystems = {
    "/" = {
      device = "/dev/mapper/system";
      fsType = "btrfs";
      options = [
        "defaults"
        "x-mount.mkdir"
        "compress=zstd"
        "ssd"
        "noatime"
        "subvol=@root"
      ];
    };

    "/home" = {
      device = "/dev/mapper/system";
      fsType = "btrfs";
      options = [
        "defaults"
        "x-mount.mkdir"
        "compress=zstd"
        "ssd"
        "noatime"
        "subvol=@home"
      ];
    };

    "/nix" = {
      device = "/dev/mapper/system";
      fsType = "btrfs";
      options = [
        "defaults"
        "x-mount.mkdir"
        "compress=zstd"
        "ssd"
        "noatime"
        "subvol=@nix"
      ];
    };

    "/var/log" = {
      device = "/dev/mapper/system";
      fsType = "btrfs";
      options = [
        "defaults"
        "x-mount.mkdir"
        "compress=zstd"
        "ssd"
        "noatime"
        "subvol=@var_log"
      ];
      neededForBoot = true;
    };

    "/swap" = {
      device = "/dev/mapper/system";
      fsType = "btrfs";
      options = [
        "defaults"
        "x-mount.mkdir"
        "compress=zstd"
        "ssd"
        "noatime"
        "subvol=@swap"
      ];
    };

    "/tmp" = {
      device = "/dev/mapper/system";
      fsType = "btrfs";
      options = [
        "defaults"
        "x-mount.mkdir"
        "compress=zstd"
        "ssd"
        "noatime"
        "subvol=@tmp"
      ];
    };

    "/.snapshots" = {
      device = "/dev/mapper/system";
      fsType = "btrfs";
      options = [
        "defaults"
        "x-mount.mkdir"
        "compress=zstd"
        "ssd"
        "noatime"
        "subvol=@snapshots"
      ];
    };

    "/persist" = {
      device = "/dev/mapper/system";
      fsType = "btrfs";
      options = [
        "defaults"
        "x-mount.mkdir"
        "compress=zstd"
        "ssd"
        "noatime"
        "subvol=@persist"
      ];
      neededForBoot = true;
    };

    "/boot" = {
      device = "/dev/disk/by-label/EFI";
      fsType = "vfat";
      options = [ "umask=0077" ];
    };
  };

  swapDevices = [
    { device = "/swap/swapfile"; }
  ];
}
