{ username, ... }: {
  imports = [
    ./darwin-configuration.nix
    ./system.nix
    ./homebrew.nix
  ];

  users.users."${username}".home = "/Users/${username}";
}
