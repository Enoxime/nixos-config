{ hostname, sopsSecretPath, ... }: {
  sops = {
    age.keyFile = "${sopsSecretPath}";
    defaultSopsFile = ../../secrets/${hostname}/secrets.yaml;
  };
}
