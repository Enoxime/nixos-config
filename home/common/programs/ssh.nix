{username, hostname, ...}: {
  programs = {
    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks."*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
      extraConfig = ''
        Host github.com
          Hostname github.com
          User git
          Port 22
          IdentityFile "''${HOME}/${username}/.ssh/${username}_${hostname}"

        Host bitbucket.org
          Hostname bitbucket.org
          User git
          port 22
          IdentityFile "''${HOME}/${username}/.ssh/${username}_${hostname}"
      '';
    };
  };

  services.ssh-agent.enable = true;
}