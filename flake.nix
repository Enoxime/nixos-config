{
  description = "Enoxime NixOS configuration";

  nixConfig = {
    experimental-features = [
      "flakes"
      "nix-command"
    ];
    extra-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
      # "https://nix-gaming.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      # "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];
  };

  inputs = {
    # NixOS official package source, using the nixos-25.05 branch here
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    # NixOS offical unstable package source
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # https://github.com/NixOS/nixos-hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # home-manager, used for managing user configuration
    home-manager = {
      # url = "github:nix-community/home-manager/release-25.05";
      url = "github:nix-community/home-manager";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Disko: Partition and format your disks
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    # TODO: Test hyprland-plugins
    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins";
    #   inputs.hyprland.follows = "hyprland";
    # };
    pyprland.url = "github:hyprland-community/pyprland";

    # Catppuccin theme https://catppuccin.com/
    # https://nix.catppuccin.com/
    catppuccin.url = "github:catppuccin/nix";

    # See https://budimanjojo.github.io/talhelper/latest/installation/
    talhelper.url = "github:budimanjojo/talhelper";

    # SOPS https://github.com/Mic92/sops-nix
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # https://github.com/nix-community/impermanence
    impermanence.url = "github:nix-community/impermanence";

    # https://github.com/fufexan/nix-gaming
    nix-gaming.url = "github:fufexan/nix-gaming";

    # # https://github.com/nix-community/nixpkgs-xr
    # nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";

    # https://amber-lang.com/
    amber.url = "github:amber-lang/Amber";

    # https://github.com/nix-community/nix-vscode-extensions
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    # https://github.com/feschber/lan-mouse
    lan-mouse.url = "github:feschber/lan-mouse";

    # https://github.com/hraban/mac-app-util
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs = inputs@{
    self,
    nixpkgs,
    nixos-hardware,
    home-manager,
    disko,
    hyprland,
    # pyprland,
    catppuccin,
    talhelper,
    sops-nix,
    nix-darwin,
    impermanence,
    amber,
    nix-vscode-extensions,
    mac-app-util,
    ...
  }:
  let
    basicConfig = if builtins.pathExists ./private.nix then
        import ./private.nix
    else
      if builtins.pathExists /persist/private/private.nix then
        import /persist/private/private.nix
      else {}
    ;

    basicExtraGroups = [
      "docker"
      "podman"
      "input"
      "incus-admin"
      "kvm"
      "libvirtd"
      "networkmanager"
      "qemu"
      "wheel"
    ];

    inherit (nixpkgs.lib) nixosSystem;
    inherit (nix-darwin.lib) darwinSystem;
    # supportedSystems = [
    #   "x86_64-linux"
    #   "aarch64-darwin"
    # ];

    createNixosConfiguration = {
      system,
      username,
      hostname,
      extraGroups ? [],
      modules ? [],
      includeHomeManager ? false,
      homeManagerModules ? [],
      installDiskName ? ""
    }:
    let
      sopsSecretPath =
        if builtins.pathExists /home/${username}/.config/sops/age/keys.txt then
          "/home/${username}/.config/sops/age/keys.txt"
        else
          "/persist/sops/age/keys.txt"
        ;

      userExtraGroups =
        if (extraGroups != []) then
          basicExtraGroups ++ extraGroups
        else
          basicExtraGroups;
    in
    nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs;
        inherit username hostname userExtraGroups sopsSecretPath installDiskName;
      };
      modules = [
        # ./hosts/functions
        ./hosts/common
        ./hosts/common/gnu-linux
        ./hosts/${hostname}
        sops-nix.nixosModules.sops
      ]
      ++ (
        if includeHomeManager then [
          home-manager.nixosModules.home-manager {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              # https://github.com/nix-community/home-manager/blob/8c3b2a0cab64a464de9e41a470eecf1318ccff57/nixos/common.nix#L55
              backupFileExtension = "backup";
              users."${username}".imports = [
                ./home/common
                ./home/common/gnu-linux
                ./home/${hostname}/home.nix
              ]
              ++ homeManagerModules;
              extraSpecialArgs = {
                inherit inputs;
                inherit username hostname;
              };
              sharedModules = [
                sops-nix.homeManagerModules.sops
              ];
            };
          }
        ]
        else []
      )
      ++ modules;
    };

    createDarwinConfiguration = {
      system,
      username,
      hostname,
      modules ? [],
      includeHomeManager ? false,
      homeManagerModules ? []
    }:
    let
      sopsSecretPath = "/Users/${username}/.config/sops/age/keys.txt";
    in
    darwinSystem {
      inherit system;
      specialArgs = {
        inherit inputs;
        inherit username hostname sopsSecretPath;
      };
      modules = [
        ./hosts/common
        ./hosts/${hostname}
        sops-nix.darwinModules.sops
        mac-app-util.darwinModules.default
      ]
      ++ (
        if includeHomeManager then [
          home-manager.darwinModules.home-manager {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              # https://github.com/nix-community/home-manager/blob/8c3b2a0cab64a464de9e41a470eecf1318ccff57/nixos/common.nix#L55
              backupFileExtension = "backup";
              users."${username}".imports = [
                ./home/common
                ./home/${hostname}/home.nix
              ]
              ++ homeManagerModules;
              extraSpecialArgs = {
                inherit inputs;
                inherit username hostname;
              };
              sharedModules = [
                sops-nix.homeManagerModules.sops
                mac-app-util.homeManagerModules.default
              ];
            };
          }
        ]
        else []
      )
      ++ modules;
    };
  in
  {
    nixosConfigurations = {
      framework = createNixosConfiguration {
        system = "x86_64-linux";
        username = "${basicConfig.bubule.username}";
        hostname = "bubule";
        modules = [
          # Add your model from this list: https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
          # https://github.com/NixOS/nixos-hardware/blob/master/framework/16-inch/7040-amd
          nixos-hardware.nixosModules.framework-16-7040-amd
          # disko.nixosModules.disko
          # {
          #   imports = [ ./hosts/bubule/disko-configuration.nix ];
          # }
          hyprland.nixosModules.default
          catppuccin.nixosModules.catppuccin
          ({ ... }: {
            nixpkgs.overlays = [
              talhelper.overlays.default
              nix-vscode-extensions.overlays.default
            ];
          })
        ];
        includeHomeManager = true;
        homeManagerModules = [
          catppuccin.homeModules.catppuccin
        ];
      };

      desktop = createNixosConfiguration {
        system = "x86_64-linux";
        username = "${basicConfig.monolith.username}";
        hostname = "monolith";
        extraGroups = ["adbusers"];
        modules = [
          disko.nixosModules.disko
          {
            imports = [ ./hosts/monolith/disko-configuration.nix ];
          }
          impermanence.nixosModules.impermanence
          hyprland.nixosModules.default
          catppuccin.nixosModules.catppuccin
          ({ ... }: {
            nixpkgs.overlays = [
              talhelper.overlays.default
              nix-vscode-extensions.overlays.default
            ];
          })
        ];
        includeHomeManager = true;
        homeManagerModules = [
          catppuccin.homeModules.catppuccin
          inputs.lan-mouse.homeManagerModules.default
        ];
      };
    };

    darwinConfigurations = {
      work = createDarwinConfiguration {
        system = "aarch64-darwin";
        username = "${basicConfig.ceramiq.username}";
        hostname = "ceramiq";
        modules = [
          ({ ... }: {
            nixpkgs.overlays = [
              talhelper.overlays.default
              nix-vscode-extensions.overlays.default
            ];
          })
        ];
        includeHomeManager = true;
        homeManagerModules = [
          catppuccin.homeModules.catppuccin
          inputs.lan-mouse.homeManagerModules.default
        ];
      };
    };
  };
}
