{ pkgs, ... }:

{
  # Enable the Flakes feature and the accompanying new nix command-line tool
  #nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot = {
    consoleLogLevel = 3;

    # https://wiki.nixos.org/wiki/QEMU
    binfmt.emulatedSystems = [
      "aarch64-linux"
      "riscv64-linux"
    ];

    initrd = {
      systemd.enable = true;
      # luks.devices."system".device = "/dev/disk/by-partlabel/cryptsystem";
      # luks.devices."system".device = "/dev/disk/by-partlabel/disk-main-luks";
      # luks.devices."cryptsystem" = {
      #   device = "/dev/disk/by-partlabel/cryptsystem";
      #   allowDiscards = true;
      # };
      # To get a fresh clean root device
      # postDeviceCommands = lib.mkAfter ''
      #   mkdir /mnt
      #   mount -t btrfs /dev/mapper/system /mnt
      #   btrfs subvolume delete /mnt/root
      #   btrfs subvolume snapshot /mnt/root-blank /mnt/root
      # '';
    };

    kernelPackages = pkgs.linuxPackages_zen; # zen Kernel
    #kernelPackages = pkgs.linuxPackages_latest; # Kernel

    # kernelParams = [
    #   # "resume=/dev/mapper/system"
    #   # "resume_offset=%__swapfile_offset%"
    #   # "resume_offset=533760" # pour 38G
    # ];
    kernelParams = [
      "splash"
      "quiet"
    ];

    # See: https://github.com/fufexan/nix-gaming/tree/master/pkgs/star-citizen
    kernel.sysctl = {
      "vm.max_map_count" = 16777216;
      "fs.file-max" = 524288;
    };

    kernelModules = [ "nfs" ];

    loader = {
      systemd-boot = {
        enable = true;
        # Limit the number of generations to keep
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
      timeout = 2;
    };

    plymouth = {
      enable = true;
      font = "${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Regular.ttf";
      themePackages = [ pkgs.catppuccin-plymouth ];
      theme = "catppuccin-macchiato";
      # logo = "";
    };

    resumeDevice = "/dev/mapper/system";

    supportedFilesystems = [ "btrfs" ];

    tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
      # tmpfsSize = "50%";
    };
  };

  # Because libfprint and aspell are not free....
  nixpkgs.config.allowUnfree = true;

  # Perform garbage collection weekly to maintain low disk usage
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
      persistent = true;
    };

    optimise = {
      automatic = true;
      persistent = true;
    };

    settings = {
      # Optimize storage
      # You can also manually optimize the store via:
      #    nix-store --optimise
      # Refer to the following link for more details:
      # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
      auto-optimise-store = true;

      download-buffer-size = 524288000; # 500 MB
    };

    # package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  console = {
    # font = "Lat2-Terminus16";
    keyMap = "us";
    # useXkbConfig = true; # use xkb.options in tty.
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics.enable = true;
  };

  security = {
    sudo.enable = true;
    rtkit.enable = true;
    # polkit.enable = true; # Already using hyprpolkitagent
  };

  # https://wiki.nixos.org/wiki/Laptop
  # powerManagement = {
  #   enable = true;
  #   powertop.enable = true;
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      btrfs-progs
      curl
      git
      libevdev
      nfs-utils
      vim
      wget
      zstd
    ];

    variables = {
      EDITOR = "vim";
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
