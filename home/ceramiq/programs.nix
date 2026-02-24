{ pkgs, ... }: {
  programs.lan-mouse.enable = true;

  home.packages = with pkgs; [
    cfssl
    openshift
    terraform-docs
    tflint
    opencode
  ];
}
