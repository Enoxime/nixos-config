_: {
  # https://wiki.hyprland.org/Hypr-Ecosystem/hyprlock/
  programs.hyprlock = {
    enable = true;
    settings = {
      # GENERAL
      general = {
        # disable_loading_bar = true;
        hide_cursor = true;
        ignore_empty_input = true;
        fail_timeout = 1000;
      };

      # BACKGROUND
      background = [
        {
          monitor = "";
          path = "screenshot";
          color = "rgba(25, 20, 20, 1.0)";
          blur_passes = 3;
        }
      ];

      # label = [
      #   # TIME
      #   {
      #     monitor = "";
      #     # text = "cmd[update:30000] echo \"\$(date +\"%H:%M\")\"";
      #     text = "cmd[update:30000] echo \$TIME";
      #     color = "rgb(cad3f5)";
      #     font_size = 90;
      #     font_family = "JetBrains Mono Regular";
      #     position = "-130, -100";
      #     halign = "right";
      #     valign = "top";
      #     shadow_passes = 2;
      #   }

      #   # DATE 
      #   {
      #     monitor = "";
      #     text = "cmd[update:43200000] echo \"\$(date +\"%A, %d %B %Y\")\"";
      #     color = "rgb(cad3f5)";
      #     font_size = 25;
      #     font_family = "JetBrains Mono Regular";
      #     position = "-130, -250";
      #     halign = "right";
      #     valign = "top";
      #     shadow_passes = 2;
      #   }

      #   # KEYBOARD LAYOUT
      #   {
      #     monitor = "";
      #     text = "\$LAYOUT";
      #     color = "rgb(cad3f5)";
      #     font_size = 20;
      #     font_family = "JetBrains Mono Regular";
      #     rotate = 0; # degrees, counter-clockwise
      #     position = "-130, -310";
      #     halign = "right";
      #     valign = "top";
      #     shadow_passes = 2;
      #   }
      # ];

      # # USER AVATAR
      # # image = [
      # #   {
      # #     monitor = "";
      # #     path = "\$HOME/.face";
      # #     size = 350;
      # #     rounding = "-1";
      # #     position = "0, 75";
      # #     halign = "center";
      # #     valign = "center";
      # #     shadow_passes = 2;
      # #   }
      # # ];

      # # INPUT FIELD
      # input-field = [
      #   {
      #     monitor = "";
      #     size = "400, 70";
      #     outline_thickness = 4;
      #     dots_size = "0.2";
      #     dots_spacing = "0.2";
      #     dots_center = true;
      #     inner_color = "rgb(363a4f)";
      #     font_color = "rgb(cad3f5)";
      #     fade_on_empty = false;
      #     placeholder_text = "<span foreground=\"##cad3f5\"><i>󰌾 Logged in as </i><span foreground=\"##8bd5ca\">\$USER</span></span>";
      #     hide_input = false;
      #     check_color = "rgb(91d7e3)";
      #     fail_color = "rgb(ed8796)";
      #     fail_text = "<i>\$FAIL <b>(\$ATTEMPTS)</b></i>";
      #     capslock_color = "rgb(eed49f)";
      #     position = "0, -185";
      #     halign = "center";
      #     valign = "center";
      #     shadow_passes = 2;
      #   }
      # ];
    };
  };
}
