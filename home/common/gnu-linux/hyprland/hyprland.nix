_: {
  wayland.windowManager.hyprland = {
    enable = true; # enable Hyprland
    systemd = {
      enable = true;
      enableXdgAutostart = true;
    };
    xwayland.enable = true;
    settings = {
      exec-once = [
        "swww query || swww-daemon & $HOME/.config/swww/swww_randomize.sh $HOME/.config/swww/wallpapers/wallpapers 60"
        "systemctl --user start hyprpolkitagent"
        "wl-paste --type text --watch cliphist store" # Stores only text data
        "wl-paste --type image --watch cliphist store" # Stores only image data
        "gammastep-indicator"
      ];

      general = {
        gaps_in = 1;
        gaps_out = 5;
        "col.inactive_border" = "$base";
        "col.active_border" = "$text";
        resize_on_border = true;
        extend_border_grab_area = 15;
        hover_icon_on_border = true;
        allow_tearing = true;
        resize_corner = 3;
      };

      decoration = {
        rounding = 10;
        blur = {
          enabled = false;
        };
        shadow = {
          enabled = false;
        };
      };

      animations = {
        animation = [
          "windows, 1, 5, default, popin 50%"
          "workspaces, 1, 1, default, fade"
        ];
      };

      input = {
        kb_layout = "us";
        numlock_by_default = false;

        touchpad = {
          disable_while_typing = true;
          tap-to-click = true;
          tap-and-drag = true;
        };
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        background_color = "$accent";
      };

      cursor = {
        inactive_timeout = 5;
        hide_on_key_press = true;
      };

      "$mod" = "SUPER";

      bind = [
        # Switch workspaces with mod + [0-9] for the internal monitor
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9] for the internal monitor
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        "$mod, v, togglefloating,"
        "$mod, f, fullscreen,"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        # "$mod, mouse:272, exec, kitty"

        # Volume
        ", XF86AudioPlay, exec, playerctl --all-players play-pause"    # Pause audio/video
        ", XF86AudioMute, exec, volumectl toggle-mute"                 # Mute audio
        ", XF86AudioMicMute, exec, volumectl -m toggle-mute"           # Mute mic

        # Turn Off Laptop Display on Lid Close
        ", switch:on:Lid Switch, exec, hyprctl dispatch dpms off"
        ", switch:off:Lid Switch, exec, hyprctl dispatch dpms on"

        # Screenshot
        ", Print, exec, bash ~/.config/hypr/scripts/screenshot.sh"

        # Color picker
        "$mod, p, exec, bash ~/.config/hypr/scripts/colorpicker.sh"

        # Lock pc
        "$mod, L, exec, hyprlock"

        "$mod, Q, killactive"
        "$mod, D, exec, rofi -show drun"
      ];

      binde = [
        # Brightness
        ", XF86MonBrightnessUp, exec, lightctl up"
        ", XF86MonBrightnessDown, exec, lightctl down"

        # Volume
        ", XF86AudioRaiseVolume, exec, volumectl -u up"   # Increase Volume
        ", XF86AudioLowerVolume, exec, volumectl -u down" # Decrease Volume
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
      ];
    };
    extraConfig = ''
      # window resize
      bind = $mod, r, submap, resize
      submap = resize
      binde = , right, resizeactive, 10 0
      binde = , left, resizeactive, -10 0
      binde = , up, resizeactive, 0 -10
      binde = , down, resizeactive, 0 10
      bind = , escape, submap, reset
      submap = reset
    '';
  };

  home.file = {
    "colorpicker.sh" = {
      enable = true;
      executable = true;
      target = "./.config/hypr/scripts/colorpicker.sh";
      text = ''
        #!/bin/bash

        # Checking and installing dependencies
        dependencies=("hyprpicker" "convert")
        for dep in "''${dependencies[@]}"; do
          command -v "$dep" &> /dev/null || { echo "$dep not found, please install it."; exit 1; }
        done

        # Get color from hyprpicker and copy it in the clipboard
        color=$(hyprpicker -a)

        # Set image path for notification
        image=/tmp/''${color}.png

        # Generate color image using ImageMagick
        convert -size 32x32 xc:"$color" "$image"

        # Display notification with color information
        if [[ "$color" ]]; then
          dunstify -t 3000 -u low -a colorpicker -i "$image" "$color, copied to clipboard."
        fi

      '';
    };

    "screenshot.sh" = {
      enable = true;
      executable = true;
      target = "./.config/hypr/scripts/screenshot.sh";
      text = ''
        #!/bin/bash

        # Checking and installing dependencies
        dependencies=("slurp" "grim" "convert" "swappy")
        for dep in "''${dependencies[@]}"; do
          command -v "$dep" &> /dev/null || { echo "$dep not found, please install it."; exit 1; }
        done

        # Capture screenshot
        screenshot="$(slurp)"

        # Process the screenshot and copy to clipboard
        grim -g "$screenshot" - | convert - -shave 2x2 PNG:- | wl-copy

        # Notify screenshot has copied to clipboard
        dunstify -t 3000 -u low -a screenshot "Screenshot copied to clipboard"

        # Paste to clipboard and use swappy for further processing
        wl-paste | swappy -f -

      '';
    };
  };
}
