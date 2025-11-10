{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fira-code
    fira-code-symbols
    font-awesome
    jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.arimo
    nerd-fonts.fantasque-sans-mono
    nerd-fonts.fira-code
    nerd-fonts.symbols-only
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      emoji = [
        "NotoColorEmoji"
      ];
      monospace = [
        "NotoSansMono"
      ];
      # sansSerif = [
      #   ""
      # ];
      serif = [
        "NotoSerifDisplay"
      ];
    };
  };
}
