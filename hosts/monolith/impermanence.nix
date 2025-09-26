_: {
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

  # TODO: Does not work. I don't know why. To investigate
  # boot.initrd.systemd.services.rollback = {
  #   description = "Rollback BTRFS root subvolume to a pristine state";
  #   wantedBy = ["initrd.target"];

  #   # LUKS/TPM process. If you have named your device mapper something other
  #   # than 'enc', then @enc will have a different name. Adjust accordingly.
  #   after = ["systemd-cryptsetup@enc.service"];

  #   # Before mounting the system root (/sysroot) during the early boot process
  #   before = ["sysroot.mount"];

  #   unitConfig.DefaultDependencies = "no";
  #   serviceConfig.Type = "oneshot";
  #   script = ''
  #     echo "Rollback running"
  #     mkdir -p /mnt
  #     mount -t btrfs /dev/mapper/system /mnt

  #     # Recursively delete all nested subvolumes inside /mnt/root
  #     btrfs subvolume list -o /mnt/@root | cut -f9 -d' ' | while read subvolume; do
  #       echo "Deleting @$subvolume subvolume..."
  #       btrfs subvolume delete "/mnt/$subvolume"
  #     done

  #     echo "Deleting @root subvolume..."
  #     btrfs subvolume delete /mnt/@root

  #     echo "Restoring blank @root subvolume..."
  #     btrfs subvolume snapshot /mnt/@root-blank /mnt/@root

  #     umount /mnt
  #   '';
  # };
}
