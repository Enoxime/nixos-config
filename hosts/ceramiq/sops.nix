{ homePath, hostname, ... }: {
  sops = {
    age.keyFile = "/${homePath}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/${hostname}/secrets.yaml;
  };
}
