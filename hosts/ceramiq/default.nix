{ username, ... }: {
  imports = [
    ./darwin-configuration.nix
    ./system.nix
    ./homebrew.nix
    ./yabai.nix
  ];

  users.users."${username}".home = "/Users/${username}";
}
