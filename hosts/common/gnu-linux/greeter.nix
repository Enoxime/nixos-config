{ pkgs, lib, ... }: {
  environment.systemPackages = [
    pkgs.tuigreet
  ];

  # Enable Display Manager
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # https://github.com/apognu/tuigreet?tab=readme-ov-file
        command = lib.concatStrings [
          "${pkgs.tuigreet}/bin/tuigreet "
          "--time --time-format '%H:%M | %a • %h | %F' "
          "--power-shutdown 'systemctl poweroff' "
          "--power-reboot 'systemctl reboot' "
          "--cmd start-hyprland"
        ];
        user = "greeter";
      };
    };
  };
}
