{ username, ... }: {
  # Sources:
  # https://www.notashelf.dev/posts/impermanence
  # https://github.com/nix-community/impermanence

  environment.persistence."/persist" ={
    enable = true;
    hideMounts = true;
    directories = [
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      "/etc/machine-id"
    ];
    # users."${username}" = {
    #   directories = [
    #     "Downloads"
    #     "Pictures"
    #     "Documents"
    #     ".ansible"
    #     ".cache"
    #     ".config"
    #     ".gnupg"
    #     ".java"
    #     ".krew"
    #     ".librewolf"
    #     ".local"
    #     ".mozilla"
    #     ".npm"
    #     ".pki"
    #     ".ssh"
    #     ".talos"
    #     ".tenv"
    #   ];
    #   files = [
    #     ".aspell.en.prepl"
    #     ".aspell.en.pws"
    #     ".bash_history"
    #     ".kube/config"
    #     ".languagetool.cfg"
    #     ".zsh_history"
    #   ];
    # };
  };

  boot.initrd.systemd.services.rollback = {
    description = "Rollback BTRFS root subvolume to a pristine state";
    wantedBy = ["initrd.target"];

    # LUKS/TPM process. If you have named your device mapper something other
    # than 'enc', then @enc will have a different name. Adjust accordingly.
    after = ["systemd-cryptsetup@enc.service"];

    # Before mounting the system root (/sysroot) during the early boot process
    before = ["sysroot.mount"];

    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir -p /mnt

      # We first mount the BTRFS root to /mnt
      # so we can manipulate btrfs subvolumes.
      mount -o subvol=@root /dev/mapper/cryptsystem /mnt

      # While we're tempted to just delete /root and create
      # a new snapshot from /root-blank, /root is already
      # populated at this point with a number of subvolumes,
      # which makes `btrfs subvolume delete` fail.
      # So, we remove them first.
      #
      # /root contains subvolumes:
      # - /root/var/lib/portables
      # - /root/var/lib/machines

      btrfs subvolume list -o /mnt |
        cut -f9 -d' ' |
        while read subvolume; do
          echo "deleting /$subvolume subvolume..."
          btrfs subvolume delete "/mnt/$subvolume"
        done &&
        echo "deleting /@root subvolume..." &&
        btrfs subvolume delete /mnt
      echo "restoring blank /root subvolume..."
      btrfs subvolume snapshot /mnt/root-blank /mnt

      # Once we're done rolling back to a blank snapshot,
      # we can unmount /mnt and continue on the boot process.
      umount /mnt
    '';
  };
}
