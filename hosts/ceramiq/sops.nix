{ username, hostname }: {
  sops = {
    age.keyFile = "/Users/${username}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/${hostname}/secrets.yaml;
  };
}
