{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.greetd.tuigreet
  ];

  # programs.regreet = {
  #   enable = true;
  #   # font = {
  #   #   name = "";
  #   # };
  # };

  # # Hyprland config for greetd.regreet
  # hyprlanRegreet = pkgs.writeText "hyprland_regreet"
  # ''
  #   exec-once = regreet; hyprctl dispatch exit
  #   misc {
  #     disable_hyprland_logo = true
  #     disable_splash_rendering = true
  #     disable_hyprland_qtutils_check = true
  #   }
  # '';

  # Enable Display Manager
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # https://github.com/apognu/tuigreet?tab=readme-ov-file
        command = ''
          ${pkgs.greetd.tuigreet}/bin/tuigreet \
            --time --time-format '%H:%M | %a • %h | %F' \
            --cmd Hyprland
        '';
        # command = "Hyprland --config ${hyprlanRegreet}";
        # user = "${username}";
        user = "greeter";
      };
    };
  };
}
