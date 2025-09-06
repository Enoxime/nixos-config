{username, hostname, ...}: {
  programs = {
    ssh = {
      enable = true;
      extraConfig = ''
        Host github.com
          Hostname github.com
          User git
          Port 22
          IdentityFile "/home/${username}/.ssh/${username}${hostname}"

        Host bitbucket.org
          Hostname bitbucket.org
          User git
          port 22
          IdentityFile "/home/${username}/.ssh/${username}${hostname}"
      '';
    };
  };

  services.ssh-agent.enable = true;
}