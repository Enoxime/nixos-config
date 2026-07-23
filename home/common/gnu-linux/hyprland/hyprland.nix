{ lib, ... }: {
  wayland.windowManager.hyprland = {
    configType = "lua";
    enable = true; # enable Hyprland
    systemd = {
      enable = true;
      enableXdgAutostart = true;
    };
    xwayland.enable = true;
    extraConfig = ''
      local mod = "SUPER"

      hl.config({
        general = {
          gaps_in = 1,
          gaps_out = 5,
          col = {
            inactive_border = colors.base,
            active_border = colors.text,
          },
          resize_on_border = true,
          extend_border_grab_area = 15,
          hover_icon_on_border = true,
          allow_tearing = true,
          resize_corner = 3,
        },

        decoration = {
          rounding = 10,
          blur = {
            enabled = false,
          },
          shadow = {
            enabled = false,
          },
        },

        animations = {
          enabled = true,
        },

        input = {
          kb_layout = "us",
          numlock_by_default = false,

          touchpad = {
            disable_while_typing = true,
            tap_to_click = true,
            tap_and_drag = true,
          },
        },

        misc = {
          disable_hyprland_logo = true,
          disable_splash_rendering = true,
          background_color = accent,
        },

        cursor = {
          inactive_timeout = 5,
          hide_on_key_press = true,
        },
      })

      hl.animation = ({ leaf = "windows", enabled = true, speed = 5, curve = "default", style = "popin 50%" })
      hl.animation = ({ leaf = "workspaces", enabled = true, speed = 1, curve = "default", style = "fade" })

      hl.gesture({
        fingers = 3,
        direction = "horizontal",
        action = "workspace"
      })

      hl.on("hyprland.start", function()
        hl.exec_cmd("awww query || awww-daemon & $HOME/.config/awww/awww_randomize.sh $HOME/.config/awww/wallpapers/wallpapers 60")
        hl.exec_cmd("systemctl --user start hyprpolkitagent")

        -- Stores only text data
        hl.exec_cmd("wl-paste --type text --watch cliphist store")

        -- Stores only image data
        hl.exec_cmd("wl-paste --type image --watch cliphist store")

        hl.exec_cmd("gammastep-indicator")
      end)

      for i = 1, 10 do
        local key = i % 10 -- 10 maps to key 0
        hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i}))
        hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
      end

      hl.bind(mod .. " + v", hl.dsp.window.float())
      hl.bind(mod .. " + f", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
      hl.bind(mod .. " + left", hl.dsp.focus({ direction = "left" }))
      hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
      hl.bind(mod .. " + up", hl.dsp.focus({ direction = "up" }))
      hl.bind(mod .. " + down", hl.dsp.focus({ direction = "down" }))

      -- Turn Off Laptop Display on Lid Close
      hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("hyprctl dispatch dpms off"), { locked = true })
      hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("hyprctl dispatch dpms on"), { locked = true; })

      -- Screenshot
      hl.bind("Print", hl.dsp.exec_cmd("bash ~/.config/hypr/scripts/screenshot.sh"))

      -- Color picker
      hl.bind(mod .. " + p", hl.dsp.exec_cmd("bash ~/.config/hypr/scripts/colorpicker.sh"))

      -- Lock pc
      hl.bind(mod .. " + L", hl.dsp.exec_cmd("hyprlock"))

      hl.bind(mod .. " + Q", hl.dsp.window.close())
      hl.bind(mod .. " + D", hl.dsp.exec_cmd("rofi -show drun"))

      -- Brightness
      hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("lightctl up"), { repeating = true })
      hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("lightctl down"), { repeating = true })

      -- Volume
      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("volumectl -u up"), { repeating = true })
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("volumectl -u down"), { repeating = true })
      hl.bind("XF86AudioMute", hl.dsp.exec_cmd("volumectl toggle-mute"))
      hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("volumectl -m toggle-mute"))
      hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl --all-players play-pause"))
      hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
      hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))

      hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })

      -- submap resize
      hl.bind(mod .. " + r", hl.dsp.submap("resize"))
      hl.define_submap("resize", function()
        -- Set repeating binds for resizing the active window.
        hl.bind("right", hl.dsp.window.resize({ x = 10, y = 0, relative = true}), { repeating = true })
        hl.bind("left", hl.dsp.window.resize({ x = -10, y = 0, relative = true}), { repeating = true })
        hl.bind("up", hl.dsp.window.resize({ x = 0, y = 10, relative = true}), { repeating = true })
        hl.bind("down", hl.dsp.window.resize({ x = 0, y = -10, relative = true}), { repeating = true })

        -- Use `reset` to go back to the global submap
        hl.bind("escape", hl.dsp.submap("reset"))
      end)
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
