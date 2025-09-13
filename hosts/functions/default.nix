{ lib, hostname, config, ... }:
# with lib; {
{
  sops = {
    age.keyFile =
      if (builtins.getEnv "sops_secret_path" != "") then
        (builtins.getEnv "sops_secret_path")
      else
        builtins.getEnv "HOME" + "/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets/secrets.yaml;
    secrets."hostnames/${hostname}/username" = {};
  };

  # options.enoxime = {
  #   username = mkOption {
  #     type = types.str;
  #     description = "Username of the system";
  #   };
  # };

  # enoxime.username = "${config.sops.secrets."hostnames/${hostname}/username".path}";

  _module.args.username = "${config.sops.secrets."hostnames/${hostname}/username".path}";
}
