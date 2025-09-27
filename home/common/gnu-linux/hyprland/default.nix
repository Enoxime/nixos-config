{ pkgs, ... }: {
  imports = [
    ./avizo.nix
    ./config.nix
    ./dunst.nix
    ./gammastep.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./rofi.nix
    ./swww.nix
    ./waybar.nix
    ./wlogout.nix
  ];

  programs = {
    # required for the default Hyprland config
    kitty = {
      enable = true;
      environment = {
        "TERM" = "xterm-256color";
      };
    };
  };

  home = {
    sessionVariables = {
      # Optional, hint Electron apps to use Wayland
      NIXOS_OZONE_WL = "1";
      BROWSER = "librewolf";
      EDITOR = "nvim";
      # SHELL = pkgs.zsh;
      TERMINAL = "kitty";

      # GPG
      GPG_TTY = "$(tty)";

      # pyenv flags to be able to install Python
      CPPFLAGS="-I${pkgs.zlib.dev}/include -I${pkgs.libffi.dev}/include -I${pkgs.readline.dev}/include -I${pkgs.bzip2.dev}/include -I${pkgs.openssl.dev}/include";
      CXXFLAGS="-I${pkgs.zlib.dev}/include -I${pkgs.libffi.dev}/include -I${pkgs.readline.dev}/include -I${pkgs.bzip2.dev}/include -I${pkgs.openssl.dev}/include";
      CFLAGS="-I${pkgs.openssl.dev}/include";
      LDFLAGS="-L${pkgs.zlib.out}/lib -L${pkgs.libffi.out}/lib -L${pkgs.readline.out}/lib -L${pkgs.bzip2.out}/lib -L${pkgs.openssl.out}/lib";
      CONFIGURE_OPTS="-with-openssl=${pkgs.openssl.dev}";
      PYENV_VIRTUALENV_DISABLE_PROMPT="1";
    };

    # Add a cursor
    # file.".icons/default".source = "${pkgs.catppuccin-cursors}/share/icons/mochaMauve";

    # https://github.com/catppuccin/cursors?tab=readme-ov-file
    # https://wiki.hyprland.org/Hypr-Ecosystem/hyprcursor/
    pointerCursor = {
      gtk.enable = true;
      name = "catppuccin-mocha-mauve-cursors";
      package = pkgs.catppuccin-cursors.mochaMauve;
      size = 32;
      sway.enable = true;
      hyprcursor = {
        enable = true;
        size = 32;
      };
    };
  };

  services = {
    # wayland clipboard manager with support for multimedia https://github.com/sentriz/cliphist
    cliphist.enable = true;

    # https://wiki.hyprland.org/Hypr-Ecosystem/hyprpaper/
    hyprpaper = {
      enable = false;
    };

    playerctld.enable = true;

    udiskie = {
      enable = true;
      automount = true;
      notify = true;
    };
  };

  home.packages = with pkgs; [
    brightnessctl
    grim
    hyprpicker # https://wiki.hyprland.org/Hypr-Ecosystem/hyprpicker/
    hyprsunset # https://wiki.hyprland.org/Hypr-Ecosystem/hyprsunset/ NOT ACTIVATED (using gammastep)
    hyprpolkitagent # https://wiki.hyprland.org/Hypr-Ecosystem/hyprpolkitagent/
    hyprsysteminfo
    hyprland-qt-support # https://wiki.hyprland.org/Hypr-Ecosystem/hyprland-qt-support/
    hyprutils
    hyprgraphics
    hyprland-qtutils
    imagemagick
    # inputs.pyprland.packages."x86_64-linux".pyprland # https://hyprland-community.github.io/pyprland/
    kdePackages.qtwayland # qt6-wayland
    libsForQt5.qt5.qtwayland # qt5-wayland
    slurp
    swappy
    swww
    wl-clipboard
  ];
}
