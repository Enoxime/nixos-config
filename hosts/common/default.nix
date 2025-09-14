{ pkgs, ... }: {
  imports = [
    ./sops.nix
  ];

  environment.systemPackages = with pkgs; [
    sops
    age
  ];
}
