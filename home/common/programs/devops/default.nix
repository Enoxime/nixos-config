{ pkgs, lib, username, ... }: {
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
      enableZshIntegration = true;
      # settings = {
      #   kubectl = lib.getExe pkgs.kubectl;
      #   paging = "auto";
      #   preset = "dark";
      #   objFreshThreshold = 10;
      # };
    };
  };

  # kubecolor catppuccin theme
  # See https://github.com/vkhitrin/kubecolor-catppuccin/tree/main
  home.file = {
    "kubecolor-catppuccin.yaml" = {
      enable = true;
      target = "./.kube/kubecolor-catppuccin.yaml";
      source = pkgs.fetchurl {
        url = "https://github.com/vkhitrin/kubecolor-catppuccin/raw/main/catppuccin-mocha.yaml";
        sha256 = "sha256-BPU8gq1RjwZ3j76OSDVWgY7hOSCq14zmgchT2OQ6Vq8=";
      };
    };

    "kubecolor.yaml" = {
      enable = true;
      target = "./.kube/kubecolor.yaml";
      text = ''
        kubectl: ${lib.getExe pkgs.kubectl}
        paging: "auto"
        objFreshThreshold: 10
      '';
    };
  };

  # pkgs.concatTextFile = {
  #   name = "color.yaml";
  #   files = [
  #     "/home/${username}/.kube/kubecolor.yaml"
  #     "/home/${username}/.kube/kubecolor-catppuccin.yaml"
  #   ];
  # };
}
