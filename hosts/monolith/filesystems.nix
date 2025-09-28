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
}
