{username, hostname, ...}: {
  programs = {
    ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "Host *" = {
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

        "Host github.com" = {
          HostName = "github.com";
          User = "git";
          Port = 22;
          IdentityFile = "~/.ssh/${username}_${hostname}";
        };

        "Host bitbucket.org" = {
          HostName = "bitbucket.org";
          User = "git";
          Port = 22;
          IdentityFile = "~/.ssh/${username}_${hostname}";
        };
      };
    };
  };
}
