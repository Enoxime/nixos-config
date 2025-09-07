{ username, homePath, ... }: {
  imports = [
    ./sops.nix
    ./darwin-configuration.nix
    ./system.nix
    ./homebrew.nix
  ];

  users.users."${username}".home = "${homePath}";
}
