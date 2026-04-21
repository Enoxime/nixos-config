{ pkgs, ... }: {
  programs.lan-mouse.enable = true;

  home.packages = with pkgs; [
    cfssl
    github-copilot-cli
    opencode
    openshift
    terraform-docs
    tflint
    uv
  ];
}
