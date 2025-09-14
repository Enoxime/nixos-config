{ pkgs, username, hostname, userExtraGroups, config, ... }: {
  sops.secrets.ssh_key = {
    mode = "0400";
    owner = username;
    group = username;
    path = "/home/${username}/.ssh/${username}_${hostname}";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users = {
      "${username}" = {
        isNormalUser = true;
        group = "${username}";
        extraGroups = userExtraGroups;
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
