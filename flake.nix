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
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
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

    # TODO: Disko does not work properly with my setup. I don't know why though
    # Disko: Partition and format your disks
    # disko = {
    #   url = "github:nix-community/disko/latest";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

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
  };

  outputs = inputs@{
    self,
    nixpkgs,
    nixos-hardware,
    home-manager,
    # disko,
    hyprland,
    # pyprland,
    catppuccin,
    talhelper,
    sops-nix,
    nix-darwin,
    ...
  }:
  let
    basic_config = if (builtins.pathExists ./private.nix) then
      (import ./private.nix) else {};

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
      modules ? [],
      includeHomeManager ? false,
      homeManagerModules ? []
    }: nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs;
        inherit username hostname;
      };
      modules = [
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
      homePath ? "/Users/${username}",
      modules ? [],
      includeHomeManager ? false,
      homeManagerModules ? []
    }: darwinSystem {
      inherit system;
      specialArgs = {
        inherit inputs;
        inherit username hostname;
      };
      modules = [
        ./hosts/${hostname}
        sops-nix.darwinModules.sops
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
                inherit username hostname homePath;
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
  in
  {
    nixosConfigurations = {
      framework = createNixosConfiguration {
        system = "x86_64-linux";
        username = "${basic_config.bubule.username}";
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
            ];
          })
        ];
        includeHomeManager = true;
        homeManagerModules = [
          catppuccin.homeModules.catppuccin
        ];
      };

      # desktop = createNixosConfiguration {
      #   system = "x86_64-linux";
      #   username = "${basic_config.monolith.username}";
      #   hostname = "monolith";
      #   modules = [];
      #   includeHomeManager = true;
      #   homeManagerModules = [];
      # };
    };

    darwinConfigurations = {
      work = createDarwinConfiguration {
        system = "aarch64-darwin";
        username = "${basic_config.ceramiq.username}";
        hostname = "ceramiq";
        homePath = "${basic_config.ceramiq.home_path}";
        modules = [
          ({ ... }: {
            nixpkgs.overlays = [
              talhelper.overlays.default
            ];
          })
        ];
        includeHomeManager = true;
        homeManagerModules = [
          catppuccin.homeModules.catppuccin
        ];
      };
    };
  };
}
