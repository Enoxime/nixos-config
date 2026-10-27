{ pkgs, ... }: {
  programs.rofi = {
    enable = true;
    settings = {
      location = 0;
      font = "FantasqueSansM Nerd Font";
      terminal = "${pkgs.wezterm}/bin/wezterm";
      modes = "drun,filebrowser,calc,emoji";
      icon-theme = "Numix-Circle";
      show-icons = true;
      drun-display-format = "{icon} {name}";
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "   Apps ";
      sidebar-mode = true;
      border-radius = 10;
    };
    plugins = [
      pkgs.rofi-calc
      # pkgs.rofi-systemd
      # pkgs.rofi-screenshot
      # pkgs.rofi-file-browser
      pkgs.rofi-emoji
    ];
  };
}
