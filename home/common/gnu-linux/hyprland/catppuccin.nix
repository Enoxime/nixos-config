_: {
  # Catppuccin theme
  # https://nix.catppuccin.com/
  # https://nix.catppuccin.com/search/rolling/
  catppuccin = {
    enable = true;
    autoEnable = true;
    # flavor = "macchiato";
    flavor = "mocha";

    # https://github.com/catppuccin/firefox
    librewolf.enable = true;
    waybar.enable = true;
    wlogout = {
      enable = true;
      accent = "red";
    };
  };
}
