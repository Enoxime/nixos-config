{ pkgs, username, hostname, userExtraGroups, config, ... }: {
  sops.secrets.ssh_key = {
    mode = "0400";
    owner = username;
    group = username;
    path = "/home/${username}/.ssh/${username}_${hostname}";
  };
  sops.secrets.password_hash.neededForUsers = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users = {
      "${username}" = {
        createHome = true;
        isNormalUser = true;
        group = "${username}";
        extraGroups = userExtraGroups;
        shell = pkgs.zsh;
        hashedPasswordFile = config.sops.secrets.password_hash.path;
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

  systemd.tmpfiles.rules = [
    "d /home/${username}/.ssh 0750 ${username} ${username} -"
    "d /home/${username}/mnt 0750 ${username} ${username} -"
    "d /home/${username}/mnt/tempon 0750 ${username} ${username} -"
  ];
}
