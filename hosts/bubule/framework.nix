# framework specifics
# https://wiki.nixos.org/wiki/Hardware/Framework/Laptop_16
{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    fprintd
    via
  ];

  services = {
    # Permit to run via for /dev/hidraw*
    udev.packages = with pkgs; [
      via
    ];

    # enable bios updates, run "fwupdmgr update" to update
    fwupd.enable = true;

    # Enable fingerprint scanner
    fprintd = {
      enable = true;
      tod.enable = true;
      tod.driver = pkgs.libfprint-2-tod1-goodix-550a;
    };

    power-profiles-daemon.enable = true;
    # https://github.com/AdnanHodzic/auto-cpufreq
    # auto-cpufreq.enable = true;

    upower.enable = true;
  };
}
