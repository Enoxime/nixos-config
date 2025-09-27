{ username, ... }: {
  fileSystems = {
    "/persist".neededForBoot = true;
    "/var/log".neededForBoot = true;

    "/home/${username}/mnt/fast_n_furious" = {
      depends = [
        "/home"
      ];
      device = "/dev/disk/by-label/fast_n_furious";
      fsType = "ext4";
      options = [
        "defaults"
        "noatime"
        "x-mount.mkdir"
        "X-mount.owner=${username}"
        "X-mount.group=${username}"
      ];
    };

    "/home/${username}/mnt/data" = {
      depends = [
        "/home"
      ];
      device = "/dev/disk/by-label/data";
      fsType = "ext4";
      options = [
        "defaults"
        "x-mount.mkdir"
        "X-mount.owner=${username}"
        "X-mount.group=${username}"
      ];
    };
  };

  # fileSystems = {
  #   "/" = {
  #     device = "/dev/mapper/system";
  #     fsType = "btrfs";
  #     options = [
  #       "defaults"
  #       "x-mount.mkdir"
  #       "compress=zstd"
  #       "ssd"
  #       "noatime"
  #       "subvol=@root"
  #     ];
  #   };

  #   "/home" = {
  #     device = "/dev/mapper/system";
  #     fsType = "btrfs";
  #     options = [
  #       "defaults"
  #       "x-mount.mkdir"
  #       "compress=zstd"
  #       "ssd"
  #       "noatime"
  #       "subvol=@home"
  #     ];
  #   };

  #   "/nix" = {
  #     device = "/dev/mapper/system";
  #     fsType = "btrfs";
  #     options = [
  #       "defaults"
  #       "x-mount.mkdir"
  #       "compress=zstd"
  #       "ssd"
  #       "noatime"
  #       "subvol=@nix"
  #     ];
  #   };

  #   "/var/log" = {
  #     device = "/dev/mapper/system";
  #     fsType = "btrfs";
  #     options = [
  #       "defaults"
  #       "x-mount.mkdir"
  #       "compress=zstd"
  #       "ssd"
  #       "noatime"
  #       "subvol=@var_log"
  #     ];
  #     neededForBoot = true;
  #   };

  #   "/.snapshots" = {
  #     device = "/dev/mapper/system";
  #     fsType = "btrfs";
  #     options = [
  #       "defaults"
  #       "x-mount.mkdir"
  #       "compress=zstd"
  #       "ssd"
  #       "noatime"
  #       "subvol=@snapshots"
  #     ];
  #   };

  #   "/persist" = {
  #     device = "/dev/mapper/system";
  #     fsType = "btrfs";
  #     options = [
  #       "defaults"
  #       "x-mount.mkdir"
  #       "compress=zstd"
  #       "ssd"
  #       "noatime"
  #       "subvol=@persist"
  #     ];
  #     neededForBoot = true;
  #   };

  #   "/boot" = {
  #     # device = "/dev/disk/by-label/EFI";
  #     device = "/dev/disk/by-partlabel/disk-main-ESP";
  #     fsType = "vfat";
  #     options = [ "umask=0077" ];
  #   };

  #   "/home/${username}/mnt/fast_n_furious" = {
  #     depends = [
  #       "/home"
  #     ];
  #     device = "/dev/disk/by-label/fast_n_furious";
  #     fsType = "ext4";
  #     options = [
  #       "defaults"
  #       "noatime"
  #       "x-mount.mkdir"
  #       "X-mount.owner=${username}"
  #       "X-mount.group=${username}"
  #     ];
  #   };

  #   "/home/${username}/mnt/data" = {
  #     depends = [
  #       "/home"
  #     ];
  #     device = "/dev/disk/by-label/data";
  #     fsType = "ext4";
  #     options = [
  #       "defaults"
  #       "x-mount.mkdir"
  #       "X-mount.owner=${username}"
  #       "X-mount.group=${username}"
  #     ];
  #   };
  # };
}
