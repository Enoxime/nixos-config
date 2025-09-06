{ pkgs, ... }: {
  # programs.firejail = {
  #   enable = true;
  #   wrappedBinaries = { 
  #     discord = {
  #       executable = "${lib.getBin pkgs.discord}/bin/discord";
  #       profile = "${pkgs.firejail}/etc/firejail/discord.profile";
  #     };
  #     thunar = {
  #       executable = "${lib.getBin pkgs.xfce.thunar}/bin/thunar";
  #       profile = "${pkgs.firejail}/etc/firejail/thunar.profile";
  #     };
  #     vscodium = {
  #       executable = "${lib.getBin pkgs.vscodium}/bin/vscodium";
  #       profile = "${pkgs.firejail}/etc/firejail/vscodium.profile";
  #     };
  #   };
  # };

  home.packages = with pkgs; [
    # https://github.com/nix-community/vulnix
    vulnix       #scan command: vulnix --system
    clamav       #scan command: sudo freshclam; clamscan [options] [file/directory/-]
    chkrootkit   #scan command: sudo chkrootkit

    # passphrase2pgp
    pass-wayland
    passExtensions.pass-tomb
    passExtensions.pass-update
    passExtensions.pass-otp
    passExtensions.pass-import
    passExtensions.pass-audit
    tomb # https://dyne.org/tomb/
    pwgen
    pwgen-secure
  ];
}
