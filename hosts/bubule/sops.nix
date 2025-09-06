{ username, hostname, ...}: {
  sops = {
    age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/${hostname}/secrets.yaml;
  };
}
