{ pkgs, ... }: {
  programs.rofi = {
    enable = true;
    font = "FantasqueSansM Nerd Font";
    location = "center";
    # pass ={};
    plugins = [
      pkgs.rofi-calc
      # pkgs.rofi-systemd
      # pkgs.rofi-screenshot
      # pkgs.rofi-file-browser
      pkgs.rofi-emoji
    ];
    terminal = "${pkgs.wezterm}/bin/wezterm";
    extraConfig = {
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
  };
}
