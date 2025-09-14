# USAGE in your configuration.nix.
# Update devices to match your hardware.
# {
#  imports = [ ./disko-config.nix ];
#  disko.devices.disk.main.device = "/dev/sda";
# }
{ username, ... }: {
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-eui.0025385981b0d512";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              label ="boot";
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                extraArgs = [
                  "-n"
                  "EFI"
                ];
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            luks = {
              size = "100%";
              label = "cryptsystem";
              content = {
                type = "luks";
                name = "system";
                settings.allowDiscards = true;
                # disable settings.keyFile if you want to use interactive password entry
                #passwordFile = "/tmp/secret.key"; # Interactive
                # settings = {
                #   allowDiscards = true;
                #   keyFile = "/tmp/secret.key";
                # };
                # additionalKeyFiles = [ "/tmp/additionalSecret.key" ];
                content = {
                  type = "btrfs";
                  extraArgs = [
                    # "--label"
                    # "system"
                    "--force"
                  ];
                  subvolumes = {
                    "@root" = {
                      mountpoint = "/";
                      mountOptions = [
                        "defaults"
                        "x-mount.mkdir"
                        "compress=zstd"
                        "ssd"
                        "noatime"
                      ];
                    };
                    "@root-blank" = {
                      mountOptions = ["subvol=root-blank" "nodatacow" "noatime"];
                    };
                    "@home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "defaults"
                        "x-mount.mkdir"
                        "compress=zstd"
                        "ssd"
                        "noatime"
                      ];
                    };
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "defaults"
                        "x-mount.mkdir"
                        "compress=zstd"
                        "ssd"
                        "noatime"
                      ];
                    };
                    "@var_log" = {
                      mountpoint = "/var/log";
                      mountOptions = [
                        "defaults"
                        "x-mount.mkdir"
                        "compress=zstd"
                        "ssd"
                        "noatime"
                      ];
                    };
                    "@snapshots" = {
                      mountpoint = "/.snapshots";
                      mountOptions = [
                        "defaults"
                        "x-mount.mkdir"
                        "compress=zstd"
                        "ssd"
                        "noatime"
                      ];
                    };
                    "@persist" = {
                      mountpoint = "/persist";
                      mountOptions = [
                        "defaults"
                        "x-mount.mkdir"
                        "compress=zstd"
                        "ssd"
                        "noatime"
                      ];
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };

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
