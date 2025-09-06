_: {
  catppuccin.waybar.enable = true;

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''
      * {
        font-family: FantasqueSansM Nerd Font; 
        min-height: 0;
      }

      window#waybar {
        font-size: 17px;
        color: @text;
        background: transparent;
        margin: 0;
        padding: 0;
        border: none;
        border-radius: 0;
      }

      box.modules-left,
      box.modules-center,
      box.modules-right {
        border-radius: 1rem;
        background-color: @surface0;
        margin: 5px 1rem 5px 1rem;
      }

      /*
        left module
      */

      #workspaces,
      #window {
        padding: 2px 10px 2px 10px;
      }

      #workspaces button {
        color: @lavender;
        border-radius: 1rem;
        padding: 0 .5rem 0 .5rem;
      }
      
      #workspaces button:hover {
        color: @sapphire;
      }

      #workspaces button.active {
        color: @sky;
        background-color: @overlay0;
      }

      #window {
        color: @peach;
        background-color: @surface1;
        border-radius: 1rem;
        margin-left: 5px;
      }

      /*
        center module
      */

      box.modules-center {
        padding: 2px 10px 2px 10px;
      }

      box.modules-center label {
        padding: 0 1rem 0 1rem;
      }

      #temperature {
        color: @maroon;
        background-color: @surface0;
        border-radius: 1rem 0 0 1rem;
      }

      #cpu {
        color: @sapphire;
        background-color: @surface1;
        background: linear-gradient(to right, @surface1, @surface0);
        border-radius: 1rem 0 0 1rem;
      }

      #memory {
        color: @green;
        background-color: @surface2;
        border-radius: 1rem 0 0 1rem;
      }

      #custom-distro {
        color: @base;
        background-color: @surface2;
      }

      #clock.time {
        color: @lavender;
        background-color: @surface2;
        border-radius: 0 1rem 1rem 0;
      }

      #clock.date {
        color: @lavender;
        background-color: @surface1;
        background: linear-gradient(to left, @surface1, @surface0);
        border-radius: 0 1rem 1rem 0;
      }

      #custom-misc {
        padding: 0 1rem 0 0;
        background-color: @surface0;
        border-radius: 0 1rem 1rem 0;
      }

      #network {
        color: @peach;
      }

      #bluetooth {
        color: @sapphire;
      }

      /*
        right module
      */

      box.modules-right {
        padding: 2px 0 2px 10px;
      }

      box.modules-right label {
        padding: 0 .5rem 0 .5rem;
      }

      #pulseaudio {
        color: @maroon;
      }

      #backlight {
        color: @yellow;
      }

      #battery {
        color: @green;
      }

      #battery.charging {
        color: @green;
      }

      #battery.warning:not(.charging) {
        color: @red;
      }

      #custom-power {
        border-radius: 1rem;
        color: @red;
        background-color: @overlay0;
      }
    '';
    settings = {
      top = {
        "layer" = "top"; # Waybar at top layer
        "position" = "top"; # Waybar position (top|bottom|left|right)
        # "width" = 1280; # Waybar width
        # Choose the order of the modules
        "modules-left" = [
          "hyprland/workspaces"
          "hyprland/window"
        ];
        "modules-center" = [
          "temperature"
          "cpu"
          "memory"
          "custom/distro"
          "clock#time"
          "clock#date"
          "group/misc"
        ];
        "modules-right" = [
          "pulseaudio"
          "backlight"
          "battery"
          # "tray"
          # "custom/lock"
          "custom/power"
          # "custom/logout_menu"
        ];

        "hyprland/workspaces" = {
          "on-click" = "activate";
        };


        "temperature" = {
          "tooltip" = false;
          "thermal-zone" = 0;
          "critical-threshold" = 80;
          interval = 5;
          "format" = "{icon} {temperatureC}󰔄";
          "format-critical" = "🔥{icon} {temperatureC}󰔄";
          "format-icons" = [
            ""
            ""
            ""
            ""
            ""
          ];
        };

        "cpu" = {
          "format" = "󰻠 {usage}%";
          tooltip = false;
          interval = 5;
          "states" = {
            "high" = 90;
            "upper-medium" = 70;
            "medium" = 50;
            "lower-medium" = 30;
            "low" = 10;
          };
          "on-click" = "wezterm start btop";
          "on-click-right" = "wezterm start btm";
        };

        "memory" = {
          "format" = " {percentage}%";
          "tooltip-format" = "Main: ({used} GiB/{total} GiB)({percentage}%), available {avail} GiB\nSwap: ({swapUsed} GiB/{swapTotal} GiB)({swapPercentage}%), available {swapAvail} GiB";
          "states" = {
            "high" = 90;
            "upper-medium" = 70;
            "medium" = 50;
            "lower-medium" = 30;
            "low" = 10;
          };
          "on-click" = "wezterm start btop";
          "on-click-right" = "wezterm start btm";
        };

        "custom/distro" = {
          format = " ";
          tooltip = false;
          on-click= "hyprsysteminfo";
        };

        "clock#time" = {
          "timezone" = "America/Toronto";
          "format" = " {:%H:%M}";
          tooltip = false;
        };

        "clock#date" = {
          "format" = "󰨳 {:%m-%d}";
          "tooltip-format" = "<tt>{calendar}</tt>";

          "calendar" = {
            "mode" = "month";
            "mode-mon-col" = 6;
            "on-click-right" = "mode";

            "format" = {
              "months" = "<span color='#b4befe'><b>{}</b></span>";
              "weekdays" = "<span color='#a6adc8' font='7'>{}</span>";
              "today" = "<span color='#f38ba8'><b>{}</b></span>";
            };
          };
        };

        "group/misc" = {
          "orientation" = "horizontal";
          "modules" = [
            "network"
            "bluetooth"
            # "custom/airplane_mode"
            # "tray"
          ];
        };

        "network" = {
          "format" = "󰤭";
          "format-wifi" = "{icon}";
          "format-icons" = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          "format-disconnected" = "󰤫 Disconnected";
          "tooltip-format" = "wifi <span color='#ee99a0'>off</span>";
          "tooltip-format-wifi" = "SSID: {essid} ({signalStrength}%), {frequency} MHz\nInterface: {ifname}\nIP: {ipaddr}\nGW: {gwaddr}\n\n<span color='#a6da95'> {bandwidthUpBits}</span>\t<span color='#ee99a0'> {bandwidthDownBits}</span>\t<span color='#c6a0f6'>󰹹 {bandwidthTotalBits}</span>";
          "tooltip-format-disconnected" = "<span color='#ed8796'>disconnected</span>";
          # "format-ethernet" = "󰈀 {ipaddr}/{cidr}";
          # "format-linked" = "󰈀 {ifname} (No IP)";
          # "tooltip-format-ethernet" = "Interface: {ifname}\nIP: {ipaddr}\nGW: {gwaddr}\nNetmask: {netmask}\nCIDR: {cidr}\n\n<span color='#a6da95'>{bandwidthUpBits}</span>\t<span color='#ee99a0'>{bandwidthDownBits}</span>\t<span color='#c6a0f6'>󰹹{bandwidthTotalBits}</span>";
          "max-length" = 35;
          "on-click" = "~/.config/waybar/scripts/wifi_toggle.sh";
          "on-click-right" = "iwgtk";
        };
        
        "bluetooth" = {
          "format" = "󰂯";
          "format-disabled" = "󰂲";
          "format-connected" = "󰂱 {device_alias}";
          "format-connected-battery" = "󰂱 {device_alias} (󰥉 {device_battery_percentage}%)";
          # preference list deciding the displayed device
          # "format-device-preference" = [
          #   "device1"
          #   "device2"
          # ];
          "tooltip-format" = "{controller_alias}\t{controller_address} ({status})\n\n{num_connections} connected";
          "tooltip-format-disabled" = "bluetooth off";
          "tooltip-format-connected" = "{controller_alias}\t{controller_address} ({status})\n\n{num_connections} connected\n\n{device_enumerate}";
          "tooltip-format-enumerate-connected" = "{device_alias}\t{device_address}";
          "tooltip-format-enumerate-connected-battery" = "{device_alias}\t{device_address}\t({device_battery_percentage}%)";
          "max-length" = 35;
          "on-click" = "~/.config/waybar/scripts/bluetooth_toggle.sh";
          "on-click-right" = "overskride";
        };

        "pulseaudio" = {
          # "scroll-step" = 1; # %, can be a float
          "format" = "{icon} {volume}%";
          "format-muted" = "";
          "format-source" = " {volume}%";
          "format-source-muted" = " {volume}%";
          "format-icons" = {
            "default" = [
              ""
              ""
              ""
            ];
            "headphone" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "speaker" = "󰓃";
            "hdmi" = "󰡁";
          };
          "on-click" = "pwvucontrol";
        };

        "backlight" = {
          "device" = "intel_backlight";
          "format" = "{icon}";
          "format-icons" = [
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
          ];
        };

        "battery" = {
          "states" = {
            "high" = 90;
            "upper-medium" = 70;
            "medium" = 50;
            "lower-medium" = 30;
            "warning" = 30;
            "critical" = 15;
            "low" = 10;
          };
          "interval" = 1;
          "format" = "{icon} {capacity}%";
          "format-charging" = "󱐋{icon} {capacity}%";
          "format-plugged" = "󰚥{icon} {capacity}%";
          "format-time" = "{H} h {M} min";
          "format-icons" = [
            "󱃍"
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          # "tooltip-format" = "{timeTo}";
        };

        "custom/power" = {
          "tooltip" = false;
          "on-click" = "[[ -z $(pidof wlogout) ]] && wlogout";
          "format" = " ";
        };
      };

      # # Top Bar Config
      # top_bar = {
      #   # Main Config
      #   "name" = "top_bar";
      #   "layer" = "top"; # Waybar at top layer
      #   "position" = "top"; # Waybar position (top|bottom|left|right)
      #   # "height" = 36; # Waybar height (to be removed for auto height)
      #   "spacing" = 4; # Gaps between modules (4px)
      #   # "width" = 1000;
      #   "modules-left" = [
      #     "hyprland/workspaces"
      #     # "hyprland/submap"
      #   ];
      #   "modules-center" = [
      #     "clock#time"
      #     "custom/separator"
      #     "clock#week"
      #     "custom/separator_dot"
      #     "clock#month"
      #     "custom/separator"
      #     "clock#calendar"
      #   ];
      #   "modules-right" = [
      #     "bluetooth"
      #     "network"
      #     # "group/misc"
      #     # "custom/logout_menu"
      #   ];

      #   # Modules Config
      #   "hyprland/workspaces" = {
      #     "on-click" = "activate";
      #     "format" = "{icon}";
      #     "format-icons" = {
      #       "1" = "󰲠";
      #       "2" = "󰲢";
      #       "3" = "󰲤";
      #       "4" = "󰲦";
      #       "5" = "󰲨";
      #       "6" = "󰲪";
      #       "7" = "󰲬";
      #       "8" = "󰲮";
      #       "9" = "󰲰";
      #       "10" = "󰿬";
      #       "special" = "";

      #       # "active" = "";
      #       # "default" = "";
      #       # "empty" = "";
      #     };
      #     "show-special" = true;
      #     "persistent-workspaces" = {
      #       "*" = 10;
      #     };
      #   };

      #   "hyprland/submap" = {
      #     "format" = "<span color='#a6da95'>Mode:</span> {}";
      #       "tooltip" = false;
      #   };

      #   "clock#time" = {
      #     "format" = "{:%I:%M %p %Ez}";
      #     "locale" = "en_US.UTF-8";
      #     "timezones" = [ "America/Toronto" ];
      #   };

      #   "custom/separator" = {
      #     "format" = "|";
      #     "tooltip" = false;
      #   };

      #   "custom/separator_dot" = {
      #     "format" = "•";
      #     "tooltip" = false;
      #   };

      #   "clock#week" = {
      #     "format" = "{:%a}";
      #   };

      #   "clock#month" = {
      #     "format" = "{:%h}";
      #   };

      #   "clock#calendar" = {
      #     "format" = "{:%F}";
      #     "tooltip-format" = "<tt><small>{calendar}</small></tt>";
      #     "actions" = {
      #       "on-click-right" = "mode";
      #     };
      #     "calendar" = {
      #       "mode"           = "month";
      #       "mode-mon-col"   = 3;
      #       "weeks-pos"      = "right";
      #       "on-scroll"      = 1;
      #       "on-click-right" = "mode";
      #       "format" = {
      #         "months" =     "<span color='#f4dbd6'><b>{}</b></span>";
      #         "days" =       "<span color='#cad3f5'><b>{}</b></span>";
      #         "weeks" =      "<span color='#c6a0f6'><b>W{}</b></span>";
      #         "weekdays" =   "<span color='#a6da95'><b>{}</b></span>";
      #         "today" =      "<span color='#8bd5ca'><b><u>{}</u></b></span>";
      #       };
      #     };
      #   };

      #   "clock" = {
      #     "format" = "{:%I:%M %p %Ez | %a • %h | %F}";
      #     "format-alt" = "{:%I:%M %p}";
      #     "tooltip-format" = "<tt><small>{calendar}</small></tt>";
      #     # "locale" = "en_US.UTF-8";
      #     # "timezones" = [
      #     #   "Europe/Kyiv"
      #     #   "America/New_York"
      #     # ];
      #     "actions" = {
      #       "on-click-right" = "mode";
      #     };
      #     "calendar" = {
      #       "mode"           = "month";
      #       "mode-mon-col"   = 3;
      #       "weeks-pos"      = "right";
      #       "on-scroll"      = 1;
      #       "on-click-right" = "mode";
      #       "format" = {
      #         "months" =     "<span color='#f4dbd6'><b>{}</b></span>";
      #         "days" =       "<span color='#cad3f5'><b>{}</b></span>";
      #         "weeks" =      "<span color='#c6a0f6'><b>W{}</b></span>";
      #         "weekdays" =   "<span color='#a6da95'><b>{}</b></span>";
      #         "today" =      "<span color='#8bd5ca'><b><u>{}</u></b></span>";
      #       };
      #     };
      #   };

      #   "custom/media" = {
      #     "format" = "{icon}󰎈";
      #     "restart-interval" = 2;
      #     "return-type" = "json";
      #     "format-icons" = {
      #       "Playing" = "";
      #       "Paused" = "";
      #     };
      #     "max-length" = 35;
      #     "exec" = "~/.config/waybar/scripts/fetch_music_player_data.sh";
      #     "on-click" = "playerctl play-pause";
      #     "on-click-right" = "playerctl next";
      #     "on-click-middle" = "playerctl prev";
      #     "on-scroll-up" = "playerctl volume 0.05-";
      #     "on-scroll-down" = "playerctl volume 0.05+";
      #     "smooth-scrolling-threshold" = "0.1";
      #   };

      #   "bluetooth" = {
      #     "format" = "󰂯";
      #     "format-disabled" = "󰂲";
      #     "format-connected" = "󰂱 {device_alias}";
      #     "format-connected-battery" = "󰂱 {device_alias} (󰥉 {device_battery_percentage}%)";
      #     # preference list deciding the displayed device
      #     # "format-device-preference" = [
      #     #   "device1"
      #     #   "device2"
      #     # ];
      #     "tooltip-format" = "{controller_alias}\t{controller_address} ({status})\n\n{num_connections} connected";
      #     "tooltip-format-disabled" = "bluetooth off";
      #     "tooltip-format-connected" = "{controller_alias}\t{controller_address} ({status})\n\n{num_connections} connected\n\n{device_enumerate}";
      #     "tooltip-format-enumerate-connected" = "{device_alias}\t{device_address}";
      #     "tooltip-format-enumerate-connected-battery" = "{device_alias}\t{device_address}\t({device_battery_percentage}%)";
      #     "max-length" = 35;
      #     "on-click" = "~/.config/waybar/scripts/bluetooth_toggle.sh";
      #     "on-click-right" = "overskride";
      #   };

      #   "network" = {
      #     "format" = "󰤭";
      #     "format-wifi" = "{icon} ({signalStrength}%) {essid} ";
      #     "format-icons" = [
      #       "󰤯"
      #       "󰤟"
      #       "󰤢"
      #       "󰤥"
      #       "󰤨"
      #     ];
      #     "format-disconnected" = "󰤫 Disconnected";
      #     "tooltip-format" = "wifi <span color='#ee99a0'>off</span>";
      #     "tooltip-format-wifi" = "SSID: {essid}({signalStrength}%), {frequency} MHz\nInterface: {ifname}\nIP: {ipaddr}\nGW: {gwaddr}\n\n<span color='#a6da95'>{bandwidthUpBits}</span>\t<span color='#ee99a0'>{bandwidthDownBits}</span>\t<span color='#c6a0f6'>󰹹{bandwidthTotalBits}</span>";
      #     "tooltip-format-disconnected" = "<span color='#ed8796'>disconnected</span>";
      #     # "format-ethernet" = "󰈀 {ipaddr}/{cidr}";
      #     # "format-linked" = "󰈀 {ifname} (No IP)";
      #     # "tooltip-format-ethernet" = "Interface: {ifname}\nIP: {ipaddr}\nGW: {gwaddr}\nNetmask: {netmask}\nCIDR: {cidr}\n\n<span color='#a6da95'>{bandwidthUpBits}</span>\t<span color='#ee99a0'>{bandwidthDownBits}</span>\t<span color='#c6a0f6'>󰹹{bandwidthTotalBits}</span>";
      #     "max-length" = 35;
      #     ~/.config/waybar/scripts/wifi_toggle.s";
      #     "on-click-right" = "iwgtk";
      #   };

      #   "group/misc" = {
      #     "orientation" = "horizontal";
      #     "modules" = [
      #       # "custom/webcam"
      #       # "privacy"
      #       # "custom/recording"
      #       # "custom/geo"
      #       # "custom/media"
      #       # "custom/dunst"
      #       "custom/night_mode"
      #       "custom/airplane_mode"
      #       # "idle_inhibitor"
      #     ];
      #   };

      #   # "custom/webcam" = {
      #   #   "interval" = 1;
      #   #   "exec" = "fish -c check_webcam";
      #   #   "return-type" = "json";
      #   # };

      #   "privacy" = {
      #     "icon-spacing" = 1;
      #     "icon-size" = 12;
      #     "transition-duration" = 250;
      #     "modules" = [
      #       {
      #         "type" = "audio-in";
      #       }
      #       {
      #         "type" = "screenshare";
      #       }
      #     ];
      #   };

      #   # "custom/recording" = {
      #   #   "interval" = 1;
      #   #   "exec-if" = "pgrep wl-screenrec";
      #   #   "exec" = "fish -c check_recording";
      #   #   "return-type" = "json";
      #   # };

      #   # "custom/geo" = {
      #   #   "interval" = 1;
      #   #   "exec-if" = "pgrep geoclue";
      #   #   "exec" = "fish -c check_geo_module";
      #   #   "return-type" = "json";
      #   # };

      #   "custom/airplane_mode" = {
      #     "return-type" = "json";
      #     "interval" = 1;
      #     "exec" = "~/.config/waybar/scripts/airplaine_mode.sh status";
      #     "on-click" = "~/.config/waybar/scripts/airplaine_mode.sh toggle";
      #   };

      #   "custom/night_mode" = {
      #     "return-type" = "json";
      #     "interval" = 1;
      #     "exec" = "~/.config/waybar/scripts/night_mode.sh status";
      #     "on-click" = "~/.config/waybar/scripts/night_mode.sh toggle";
      #   };

      #   "custom/dunst" = {
      #     "return-type" = "json";
      #     "exec" = "~/.config/waybar/scripts/dunst_mode.sh";
      #     "on-click" = "dunstctl set-paused toggle";
      #     "restart-interval" = 1;
      #   };

      #   "idle_inhibitor" = {
      #     "format" = "{icon}";
      #     "format-icons" = {
      #       "activated" = "󰛐";
      #       "deactivated" = "󰛑";
      #     };
      #     "tooltip-format-activated" = "idle-inhibitor <span color='#a6da95'>on</span>";
      #     "tooltip-format-deactivated" = "idle-inhibitor <span color='#ee99a0'>off</span>";
      #     "start-activated" = true;
      #   };

      #   "custom/logout_menu" = {
      #     "return-type" = "json";
      #     "exec" = "echo '{ \"text\":\"󰐥\"; \"tooltip\": \"logout menu\" }'";
      #     "interval" = "once";
      #     "on-click" = "~/.config/waybar/scripts/wlogout_unique.sh";
      #   };
      # };


      # # Bottom Bar Config
      # bottom_bar = {
      #   # Main Config
      #   "name" = "bottom_bar";
      #   "layer" = "top"; # Waybar at top layer
      #   "position" = "bottom"; # Waybar position (top|bottom|left|right)
      #   "height" = 36; # Waybar height (to be removed for auto height)
      #   "spacing" = 4; # Gaps between modules (4px)
      #   "modules-left" = ["user"];
      #   "modules-center" = ["hyprland/window"];
      #   "modules-right" = [
      #     "keyboard-state"
      #     "hyprland/language"
      #   ];

      #   # Modules Config
      #   "hyprland/window" = {
      #     "format" = "👼 {title} 😈";
      #     "max-length" = 50;
      #   };

      #   "hyprland/language" = {
      #     "format-en" = "🇺🇸 ENG (US)";
      #     "format-uk" = "🇺🇦 UKR";
      #     "format-ru" = "🇷🇺 RUS";
      #     "keyboard-name" = "at-translated-set-2-keyboard";
      #     "on-click" = "hyprctl switchxkblayout at-translated-set-2-keyboard next";
      #   };

      #   "keyboard-state" = {
      #     "capslock" = true;
      #     # "numlock" = true;
      #     "format" = "{name} {icon}";
      #     "format-icons" = {
      #       "locked" = "";
      #       "unlocked" = "";
      #     };
      #   };

      #   "user" = {
      #     "format" = " <span color='#8bd5ca'>{user}</span> (up <span color='#f5bde6'>{work_d} d</span> <span color='#8aadf4'>{work_H} h</span> <span color='#eed49f'>{work_M} min</span> <span color='#a6da95'>↑</span>)";
      #     "icon" = true;
      #   };
      # };


      # # Left Bar Config
      # left_bar = {
      #   # Main Config
      #   "name" = "left_bar";
      #   "layer" = "top"; # Waybar at top layer
      #   "position" = "left"; # Waybar position (top|bottom|left|right)
      #   "spacing" = 4; # Gaps between modules (4px)
      #   "width" = 75;
      #   "margin-top" = 10;
      #   "margin-bottom" = 10;
      #   "modules-left" = ["wlr/taskbar"];
      #   "modules-center" = [
      #     "cpu"
      #     "memory"
      #     "disk"
      #     "temperature"
      #     "battery"
      #     "backlight"
      #     "pulseaudio"
      #     "systemd-failed-units"
      #   ];
      #   "modules-right" = ["tray"];

      #   # Modules Config
      #   "wlr/taskbar" = {
      #     "format" = "{icon}";
      #     "icon-size" = 20;
      #     "icon-theme" = "Numix-Circle";
      #     "tooltip-format" = "{title}";
      #     "on-click" = "activate";
      #     "on-click-right" = "close";
      #     "on-click-middle" = "fullscreen";
      #   };

      #   "tray" = {
      #     "icon-size" = 20;
      #     "spacing" = 2;
      #   };

      #   "memory" = {
      #     "format" = "{percentage}%";
      #     "tooltip-format" = "Main: ({used} GiB/{total} GiB)({percentage}%), available {avail} GiB\nSwap: ({swapUsed} GiB/{swapTotal} GiB)({swapPercentage}%), available {swapAvail} GiB";
      #     "states" = {
      #       "high" = 90;
      #       "upper-medium" = 70;
      #       "medium" = 50;
      #       "lower-medium" = 30;
      #       "low" = 10;
      #     };
      #     "on-click" = "wezterm start btop";
      #     "on-click-right" = "wezterm start btm";
      #   };

      #   "disk" = {
      #     "format" = "󰋊{percentage_used}%";
      #     "tooltip-format" = "({used}/{total})({percentage_used}%) in '{path}', available {free}({percentage_free}%)";
      #     "states" = {
      #       "high" = 90;
      #       "upper-medium" = 70;
      #       "medium" = 50;
      #       "lower-medium" = 30;
      #       "low" = 10;
      #     };
      #     "on-click" = "wezterm start btop";
      #     "on-click-right" = "wezterm start btm";
      #   };

      #   "backlight" = {
      #     "format" = "{icon}{percent}%";
      #     "format-icons" = [
      #       "󰌶"
      #       "󱩎"
      #       "󱩏"
      #       "󱩐"
      #       "󱩑"
      #       "󱩒"
      #       "󱩓"
      #       "󱩔"
      #       "󱩕"
      #       "󱩖"
      #       "󰛨"
      #     ];
      #     "tooltip" = false;
      #     "states" = {
      #       "high" = 90;
      #       "upper-medium" = 70;
      #       "medium" = 50;
      #       "lower-medium" = 30;
      #       "low" = 10;
      #     };
      #     "reverse-scrolling" = true;
      #     "reverse-mouse-scrolling" = true;
      #   };

      #   "systemd-failed-units" = {
      #     "format" = "✗ {nr_failed}";
      #   };
      # };
    };
  };

  home.file = {
    "fetch_music_player_data" = {
      enable = true;
      executable = true;
      target = "./.config/waybar/scripts/fetch_music_player_data.sh";
      text = ''
        #!/usr/bin/env bash

        playerctl \
          -a metadata \
          --format "{\"text\": \"{{artist}} - {{markup_escape(title)}}\", \"tooltip\": \"<i><span color='#a6da95'>{{playerName}}</span></i>: <b><span color='#f5a97f'>{{artist}}</span> - <span color='#c6a0f6'>{{markup_escape(title)}}</span></b>\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}" \
          -F
      '';
    };

    "bluetooth_toggle" = {
      enable = true;
      executable = true;
      target = "./.config/waybar/scripts/bluetooth_toggle.sh";
      text = ''
        #!/usr/bin/env bash

        __bluetooth_status=$(rfkill list bluetooth | grep "Soft blocked: yes")
        __bluetooth_state="/tmp/bluetooth_state"

        if [[ "''${__bluetooth_status}" != *"Soft blocked: yes"* ]]; then
          rfkill block bluetooth
          touch "''${__bluetooth_state}"
        else
          rfkill unblock bluetooth
          [[ -f "''${__bluetooth_state}" ]] && rm "''${__bluetooth_state}"
        fi
      '';
    };

    "wifi_toggle" = {
      enable = true;
      executable = true;
      target = "./.config/waybar/scripts/wifi_toggle.sh";
      text = ''
        #!/usr/bin/env bash

        __wifi_status=$(rfkill list wifi | grep "Soft blocked: yes")
        __wifi_state="/tmp/wifi_state"

        if [[ "''${__wifi_status}" != *"Soft blocked: yes"* ]]; then
          rfkill block wifi
          touch "''${__wifi_state}"
        else
          rfkill unblock wifi
          [[ -f "''${__wifi_state}" ]] && rm "''${__wifi_state}"
        fi
      '';
    };

    "airplaine_mode" = {
      enable = true;
      executable = true;
      target = "./.config/waybar/scripts/airplaine_mode.sh";
      text = ''
        #!/usr/bin/env bash

        __arg="''${1:-}"
        __airplaine_state="/tmp/airplane_state"
        __bluetooth_state="/tmp/bluetooth_state"
        __wifi_state="/tmp/wifi_state"

        if [[ "''${__arg} == "toggle" ]]; then
          if [[ -f "''${__airplaine_state}" ]]; then
            [[ ! -f "''${__wifi_state}" ]] && rfkill unblock wifi
            [[ ! -f "''${__bluetooth_state}" ]] && rfkill unblock bluetooth
            rm "''${__airplaine_state}"
          else
            rfkill block wifi
            rfkill block bluetooth
            touch "''${__airplaine_state}"
          fi
        fi

        # Check airplaine status
        if [[ "''${__arg}" == "status" ]]; then
          if [[ -f "''${__airplaine_state}" ]]; then
            __airplane_status="on"
          else
            __airplane_status="off"
          fi

          echo "{ \"text\":\"󰀞\", \"tooltip\": \"airplane-mode <span color='#ee99a0'>''${__airplaine_status}</span>\", \"class\": \"''${__airplaine_status}\" }"
        fi
      '';
    };

    "night_mode" = {
      enable = true;
      executable = true;
      target = "./.config/waybar/scripts/night_mode.sh";
      text = ''
        #!/usr/bin/env bash

        __arg="''${1:-}"

        if [[ "''${arg}" == "toggle ]]; then
          if [[ $(systemctl status gammastep | grep "Active: active") == "Active: active" ]]; then
            systemctl stop gammastep
          else
            systemctl start gammastep
          fi
        fi

        # Check night status
        if [[ "''${__arg}" == "status" ]]; then

          if [[ $(systemctl status gammastep | grep "Active: active") == "Active: active" ]]; then
            __night_status="on"
          else
            __night_status="off"
          fi

          echo "{ \"text\":\"󱩌\", \"tooltip\": \"night-mode <span color='#a6da95'>''${__night_status}</span>\", \"class\": \"''${__night_status}\" }"
        fi
      '';
    };

    "dunst_mode" = {
      enable = true;
      executable = true;
      target = "./.config/waybar/scripts/dunst_mode.sh";
      text = ''
        #!/usr/bin/env bash

        __COUNT_WAITING=$(dunstctl count waiting)
        __COUNT_DISPLAYED=$(dunstctl count displayed)
        __ENABLED="{ \"text\": \"󰂜\", \"tooltip\": \"notifications <span color='#a6da95'>on</span>\", \"class\": \"on\" }"
        __DISABLED="{ \"text\": \"󰪑\", \"tooltip\": \"notifications <span color='#ee99a0'>off</span>\", \"class\": \"off\" }"
        
        if [[ "''${__COUNT_DISPLAYED}" != 0 ]]; then
            set ENABLED "{ \"text\": \"󰂚''${__COUNT_DISPLAYED}\", \"tooltip\": \"''${__COUNT_DISPLAYED} notifications\", \"class\": \"on\" }"
        fi

        if [[ "''${__COUNT_WAITING}" != 0 ]]; then
            set DISABLED "{ \"text\": \"󰂛''${__COUNT_WAITING}\", \"tooltip\": \"(silent) ''${__COUNT_WAITING} notifications\", \"class\": \"off\" }"
        fi

        if [[ dunstctl is-paused | grep "false" ]]; then
            echo $ENABLED
        else
            echo $DISABLED
        fi
      '';
    };

    "wlogout_unique" = {
      enable = true;
      executable = true;
      target = "./.config/waybar/scripts/wlogout_unique.sh";
      text = ''
        #!/usr/bin/env bash

        [[ -z $(pidof wlogout) ]] && wlogout
      '';
    };
  };
}
