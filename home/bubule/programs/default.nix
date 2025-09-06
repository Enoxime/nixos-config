{ pkgs, ... }: {
  imports = [
    # ./alacritty.nix
    ./devops
    ./development
    ./games.nix
    ./git.nix
    ./shell.nix
    ./ssh.nix
    # ./starship.nix
  ];

  programs = {
    # A lightweight multi-protocol & multi-source command-line download utility
    aria2.enable = true;
    bat.enable = true;
    # Another process monitor but seems nice
    bottom.enable = true;
    fastfetch.enable = true;
    # A command-line fuzzy finder
    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
    gpg.enable = true;
    # A lightweight and flexible command-line JSON processor
    jq.enable = true;
    # https://github.com/catppuccin/firefox
    librewolf.enable = true;
    lsd.enable = true;
    mpv = {
      enable = true;
      config = {
        hwdec = "auto-safe";
        vo = "gpu";
        profile = "gpu-hq";
        gpu-context = "wayland";
      };
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
    # https://home-manager-options.extranix.com/?query=spotify-player&release=master
    # https://github.com/aome510/spotify-player
    # https://github.com/aome510/spotify-player/blob/master/docs/config.md
    spotify-player.enable = true;
    wezterm = {
      enable = true;
      enableZshIntegration = true;
      extraConfig = ''
        return {
          color_scheme = "Catppuccin Mocha", -- or Macchiato, Frappe, Latte
        }
      '';
    };
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # here is some command line tools I use frequently

    # archives
    zip
    xz
    unzip
    p7zip
    gnutar
    lz4

    # utils
    yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils  # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc  # it is a calculator for the IPv4/v6 addresses
    iproute2 # Collection of utilities for controlling TCP/IP networking and traffic control in Linux (include bridge)
    vlan
    tcpdump
    wireshark

    # misc
    aspell # Command line spell checker. http://aspell.net/
    aspellDicts.en
    aspellDicts.en-science
    aspellDicts.en-computers
    aspellDicts.fr
    bc
    borgbackup
    brave
    cowsay
    diction # Command line grammer checker. https://www.gnu.org/software/diction/
    discord
    e2fsprogs
    exfat
    ffmpeg
    file
    gawk
    gnused
    languagetool # Proofreading program for English, French German, Polish, and more
    libde265 # Open h.265 video codec implementation
    libva1 # VAAPI library: Video Acceleration API
    manix # https://github.com/mlvzk/manix
    nemo # https://github.com/linuxmint/nemo GUI file manager
    nnn # TUI file manager
    openssl
    # opera
    # (opera.override { proprietaryCodecs = true; }) # 'opera' has been removed due to lack of maintenance in nixpkgs
    popcorntime
    sqlite
    sshpass
    tree
    which
    wireguard-tools

    # language
    go

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # productivity
    # hugo # static site generator
    glow # markdown previewer in terminal

    btop  # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring
    zfxtop # top but for gen z with x (whatever that means but its cool)
    kmon # kernel manager

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
    parted

    # security/encrypt
    sops
    age
  ];

  services = {
    # https://gitlab.com/WhyNotHugo/darkman/
    darkman = {
      enable = true;
      settings = {
        usegeoclue = false;
        lat = 45.5;
        lng = -73.5;
      };
    };

    gpg-agent = {
      enable = true;
      enableZshIntegration = true;
      grabKeyboardAndMouse = true;
      pinentry.package = pkgs.pinentry-tty;
    };
  };

  # Thunar
  # https://wiki.nixos.org/wiki/Nemo
  # xdg.desktopEntries.nemo = {
  #   name = "Nemo";
  #   exec = "${pkgs.nemo-with-extensions}/bin/nemo";
  # };
  # xdg.mimeApps = {
  #   enable = true;
  #   defaultApplications = {
  #     "inode/directory" = [ "nemo.desktop" ];
  #     "application/x-gnome-saved-search" = [ "nemo.desktop" ];
  #   };
  # };
  # dconf = {
  #   settings = {
  #     "org/cinnamon/desktop/applications/terminal" = {
  #       exec = "wezterm";
  #       # exec-arg = ""; # argument
  #     };
  #   };
  # };
}
