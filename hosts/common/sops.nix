{ pkgs, hostname, sopsSecretPath, ... }: {
  environment.systemPackages = with pkgs; [
    sops
    age
  ];

  sops = {
    age.keyFile = "${sopsSecretPath}";
    defaultSopsFile = ../../secrets/${hostname}/secrets.yaml;
  };
}
