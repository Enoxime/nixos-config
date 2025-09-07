{ pkgs, ... }: {
  home.packages = with pkgs; [
    buildah # https://buildah.io/
    firecracker # https://firecracker-microvm.github.io/
    firectl # https://github.com/firecracker-microvm/firectl
    flintlock # https://github.com/liquidmetal-dev/flintlock
    podman-compose
    podman-tui
    virt-manager # https://wiki.nixos.org/wiki/Virt-manager
    virt-viewer
  ];

  # programs = {
  #   # https://distrobox.it/
  #   distrobox.enable = true;
  # };

  services = {
    podman = {
      enable = true;
    };
  };
}
