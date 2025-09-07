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

      monitor = ",1920x1200@165.00Hz,auto,1";

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
    # extraConfig = ''
    #   exec-once = swww & waybar
    #   # exec-once = hyprsunset # wl-sunset already manage and with geo
    #   exec-once = systemctl --user start hyprpolkitagent

    #   # https://hyprland-community.github.io/pyprland/
    #   # TODO: https://hyprland-community.github.io/pyprland/wallpapers.html
    #   # exec-once = /usr/bin/pypr

    #   # Cliphist clipboard
    #   # See: https://wiki.hyprland.org/Useful-Utilities/Clipboard-Managers/#cliphist
    #   exec-once = wl-paste --type text --watch cliphist store # Stores only text data
    #   exec-once = wl-paste --type image --watch cliphist store # Stores only image data

    #   # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
    #   input {
    #     kb_layout = us,ua,ru
    #     kb_variant =
    #     kb_model =
    #     kb_options = grp:win_space_toggle
    #     kb_rules =

    #     follow_mouse = 1

    #     touchpad {
    #       natural_scroll = yes
    #       tap-and-drag = true
    #     }

    #     sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
    #   }

    #   # XWayland disable scaling
    #   # xwayland {
    #   #     force_zero_scaling = true
    #   # }

    #   # env = GDK_SCALE, 1.6
    #   env = HYPRCURSOR_THEME,Catppuccin-Macchiato-Teal
    #   env = HYPRCURSOR_SIZE,24
    #   env = XCURSOR_THEME,Catppuccin-Macchiato-Teal
    #   env = XCURSOR_SIZE,24

    #   general {
    #       # See https://wiki.hyprland.org/Configuring/Variables/ for more

    #       gaps_in = 5
    #       gaps_out = 10
    #       border_size = 2
    #       col.active_border = $teal
    #       col.inactive_border = $surface1

    #       layout = dwindle
    #   }

    #   decoration {
    #       # See https://wiki.hyprland.org/Configuring/Variables/ for more

    #       rounding = 10

    #       blur {
    #           size = 8
    #           passes = 2
    #       }

    #       shadow {
    #           enabled = true
    #           range = 15
    #           render_power = 3
    #           offset = 0, 0
    #           color = $teal
    #           color_inactive = 0xff$baseAlpha
    #       }

    #       active_opacity = 0.7
    #       inactive_opacity = 0.7
    #       fullscreen_opacity = 0.7
    #   }

    #   # layerrule = blur, waybar

    #   animations {
    #       enabled = yes

    #       # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

    #       bezier = myBezier, 0.05, 0.9, 0.1, 1.05

    #       animation = windows, 1, 2, myBezier
    #       animation = windowsOut, 1, 2, default, popin 80%
    #       animation = border, 1, 3, default
    #       animation = fade, 1, 2, default
    #       animation = workspaces, 1, 1, default
    #   }

    #   dwindle {
    #       # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
    #       pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
    #       preserve_split = yes # you probably want this
    #       smart_split = true
    #   }

    #   master {
    #       # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
    #       new_status = master
    #   }

    #   gestures {
    #       # See https://wiki.hyprland.org/Configuring/Variables/ for more
    #       workspace_swipe = on
    #   }

    #   misc {
    #       disable_hyprland_logo = true
    #       disable_splash_rendering = true
    #       background_color = 0x24273a
    #   }

    #   binds {
    #       workspace_back_and_forth = true
    #   }

    #   # Example per-device config
    #   # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
    #   device {
    #       name = epic mouse V1
    #       sensitivity = -0.5
    #   }


    #   # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more

    #   # See https://wiki.hyprland.org/Configuring/Keywords/ for more
    #   $mainMod = SUPER

    #   # will switch to a submap called resize
    #   bind=$mainMod ALT,R,submap,resize

    #   # will start a submap called "resize"
    #   submap=resize

    #   # sets repeatable binds for resizing the active window
    #   binde=,right,resizeactive,10 0
    #   binde=,left,resizeactive,-10 0
    #   binde=,up,resizeactive,0 -10
    #   binde=,down,resizeactive,0 10

    #   binde=,l,resizeactive,10 0
    #   binde=,h,resizeactive,-10 0
    #   binde=,k,resizeactive,0 -10
    #   binde=,j,resizeactive,0 10

    #   # use reset to go back to the global submap
    #   bind=,escape,submap,reset

    #   # will reset the submap, meaning end the current one and return to the global one
    #   submap=reset

    #   # will switch to a submap called move
    #   bind=$mainMod ALT,M,submap,move

    #   # will start a submap called "move"
    #   submap=move

    #   # sets repeatable binds for moving the active window
    #   bind=,right,movewindow,r
    #   bind=,left,movewindow,l
    #   bind=,up,movewindow,u
    #   bind=,down,movewindow,d

    #   bind=,l,movewindow,r
    #   bind=,h,movewindow,l
    #   bind=,k,movewindow,u
    #   bind=,j,movewindow,d

    #   # use reset to go back to the global submap
    #   bind=,escape,submap,reset

    #   # will reset the submap, meaning end the current one and return to the global one
    #   submap=reset

    #   # Brightness
    #   # bind = , code:232, exec, ~/.config/hypr/scripts/brightness.sh dec
    #   # bind = , code:233, exec, ~/.config/hypr/scripts/brightness.sh inc
    #   bind = , XF86MonBrightnessUp, exec, lightctl up
    #   bind = , XF86MonBrightnessDown, exec, lightctl down

    #   # Volume
    #   bind = , XF86AudioPlay, exec, playerctl --all-players play-pause    # Pause audio/video
    #   bind = , XF86AudioRaiseVolume, exec, volumectl -u up                # Increase Volume
    #   bind = , XF86AudioLowerVolume, exec, volumectl -u down              # Decrease Volume
    #   bind = , XF86AudioMute, exec, volumectl toggle-mute                 # Mute audio
    #   bind = , XF86AudioMicMute, exec, volumectl -m toggle-mute           # Mute mic

    #   # Screenshot
    #   bind = $mainMod, S, exec, ~/.config/hypr/scripts/screenshot.sh

    #   # Color picker
    #   bind = $mainMod, P, exec, ~/.config/hypr/scripts/colorpicker.sh

    #   # Turn Off Laptop Display on Lid Close
    #   bind = , switch:on:Lid Switch, exec, hyprctl dispatch dpms off
    #   bind = , switch:off:Lid Switch, exec, hyprctl dispatch dpms on

    #   # Lock pc
    #   bind = $mainMod SHIFT, L, exec, hyprlock

    #   bind = $mainMod, D, exec, rofi -show drun
    #   bind = $mainMod SHIFT, Q, killactive
    #   bind = $mainMod SHIFT, F, togglefloating,
    #   bind = $mainMod CTRL, F, fullscreen, 0
    #   bind = $mainMod SHIFT, P, pseudo, # dwindle
    #   bind = $mainMod SHIFT, O, togglesplit, # dwindle
    #   bind = $mainMod ALT, M, exit,

    #   # Move focus with mainMod + arrow keys
    #   bind = $mainMod, left, movefocus, l
    #   bind = $mainMod, right, movefocus, r
    #   bind = $mainMod, up, movefocus, u
    #   bind = $mainMod, down, movefocus, d
    #   bind = $mainMod, h, movefocus, l
    #   bind = $mainMod, l, movefocus, r
    #   bind = $mainMod, k, movefocus, u
    #   bind = $mainMod, j, movefocus, d
    #   bind = $mainMod, Tab, cyclenext,
    #   bind = $mainMod, Tab, bringactivetotop,

    #   # Switch workspaces with mainMod + [0-9] for the internal monitor
    #   bind = $mainMod, 1, workspace, 1
    #   bind = $mainMod, 2, workspace, 2
    #   bind = $mainMod, 3, workspace, 3
    #   bind = $mainMod, 4, workspace, 4
    #   bind = $mainMod, 5, workspace, 5
    #   bind = $mainMod, 6, workspace, 6
    #   bind = $mainMod, 7, workspace, 7
    #   bind = $mainMod, 8, workspace, 8
    #   bind = $mainMod, 9, workspace, 9
    #   bind = $mainMod, 0, workspace, 10

    #   # Move active window to a workspace with mainMod + SHIFT + [0-9] for the internal monitor
    #   bind = $mainMod SHIFT, 1, movetoworkspace, 1
    #   bind = $mainMod SHIFT, 2, movetoworkspace, 2
    #   bind = $mainMod SHIFT, 3, movetoworkspace, 3
    #   bind = $mainMod SHIFT, 4, movetoworkspace, 4
    #   bind = $mainMod SHIFT, 5, movetoworkspace, 5
    #   bind = $mainMod SHIFT, 6, movetoworkspace, 6
    #   bind = $mainMod SHIFT, 7, movetoworkspace, 7
    #   bind = $mainMod SHIFT, 8, movetoworkspace, 8
    #   bind = $mainMod SHIFT, 9, movetoworkspace, 9
    #   bind = $mainMod SHIFT, 0, movetoworkspace, 10

    #   # Scroll through existing workspaces with mainMod + scroll
    #   bind = $mainMod, mouse_down, workspace, e+1
    #   bind = $mainMod, mouse_up, workspace, e-1

    #   # Move/resize windows with mainMod + LMB/RMB and dragging
    #   bindm = $mainMod, mouse:272, movewindow
    #   bindm = $mainMod, mouse:273, resizewindow

    # '';
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
