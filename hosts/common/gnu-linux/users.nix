{ pkgs, username, userExtraGroups, ... }: {
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
