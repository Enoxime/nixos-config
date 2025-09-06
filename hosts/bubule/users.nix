{ pkgs, username, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users = {
      "${username}" = {
        isNormalUser = true;
        extraGroups = [
          "docker"
          "podman"
          "input"
          "incus-admin"
          "kvm"
          "libvirtd"
          "networkmanager"
          "qemu"
          "wheel"
        ];
        shell = pkgs.zsh;
      };
    };
    
    groups = {
      "${username}" = {
        name = "${username}";
        members = [
          "${username}"
        ];
      };
    };
  };

  programs.zsh.enable = true;
}
