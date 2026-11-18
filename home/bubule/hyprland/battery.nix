{ config, ... }: {
  home.file."battery-monitor.sh" = {
    enable = true;
    executable = true;
    target = "./.local/bin/battery-monitor.sh";
    text = ''
      #!/usr/bin/env bash
      BATTERY_PERCENTAGE=$(upower -b | grep percentage | awk '{gsub(/[^0-9]/, "", $2); print $2}' | head -n 1)
      echo "$(date '+%Y-%m-%d %H:%M:%S') - Battery: $BATTERY_PERCENTAGE%"
      if [ "$BATTERY_PERCENTAGE" -lt 10 ]; then
          dunstify "Low Battery Alert" "Battery at $BATTERY_PERCENTAGE%. Please charge soon!"
      fi
    '';
  };

  systemd.user.services.battery-monitor = {
    Service = {
      ExecStart = "${config.home.homeDirectory}/.local/bin/battery-monitor.sh";
      Persistent = true;
    };
    Unit.Description = "Trigger a dunst notification that the battery is low.";
    Install.WantedBy = [ "default.target" ];
  };

  systemd.user.timers.battery-monitor = {
    Unit.Description = "Trigger a dunst notification that the battery is low.";
    Timer = {
      Unit = "battery-monitor.service";
      OnCalendar = "*-*-* *:*:00";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
