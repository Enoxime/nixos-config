{ pkgs, ... }: {
  imports = [
    ./kubectl-plugins.nix
    ./k9s.nix
  ];

  home.packages = with pkgs; [
    cilium-cli
    cmctl # https://github.com/cert-manager/cmctl
    dive # https://github.com/wagoodman/dive
    fluxcd
    helm-docs
    krew
    # Trigger error for now. To try again later
    # krr # https://github.com/robusta-dev/krr
    kubectl
    kubectl-cnpg
    kubernetes-helm
    kubernetes-helmPlugins.helm-diff
    kubeseal
    kubevirt
    kustomize
    talhelper
    talosctl
    tenv
    velero
  ];

  programs = {
    kubecolor = {
      enable = true;
      enableAlias = true;
      settings = {
        paging = "auto";
      };
    };
  };

  # kubecolor catppuccin theme
  # See https://github.com/vkhitrin/kubecolor-catppuccin/tree/main
  home.file."color.yaml" = {
    enable = true;
    target = "./.kube/color.yaml";
    source = pkgs.fetchurl {
      url = "https://github.com/vkhitrin/kubecolor-catppuccin/raw/main/catppuccin-mocha.yaml";
      sha256 = "sha256-BPU8gq1RjwZ3j76OSDVWgY7hOSCq14zmgchT2OQ6Vq8=";
    };
  };
}
