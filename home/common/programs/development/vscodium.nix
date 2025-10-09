{ pkgs, config, ... }: {
  home.packages = with pkgs; [
    nixd
    nixpkgs-fmt
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles."default" = {
      enableUpdateCheck = true;
      enableExtensionUpdateCheck = true;
      extensions = with pkgs.nix-vscode-extensions.vscode-marketplace; [
        bierner.markdown-mermaid
        bierner.markdown-preview-github-styles
        catppuccin.catppuccin-vsc
        # catppuccin.catppuccin-vsc-icons
        davidanson.vscode-markdownlint
        hashicorp.terraform
        jnoortheen.nix-ide
        ms-python.python
        ms-python.debugpy
        ph0enixkm.amber-language
        redhat.ansible
        redhat.vscode-yaml
        # streetsidesoftware.code-spell-checker
        tamasfe.even-better-toml
        wholroyd.jinja
        github.copilot
        github.copilot-chat
        continue.continue
      ];
      userSettings = {
        "ansible.lightspeed.enabled" = false;
        catppuccin-icons.specificFolders = true;
        "explorer.confirmDragAndDrop" = false;
        editor = {
          "racketPairColorization.independentColorPoolPerBracketType" = true;
          fontFamily = "'FiraCode Nerd Font', 'Droid Sans Mono', 'monospace', monospace";
          fontLigatures = true;
          rulers = [
              80
              120
          ];
          semanticHighlighting.enabled = true;
          tabSize = 2;
        };
        files = {
          associations = {
            "**/ansible/**/*.yaml" = "ansible";
            "**/ansible/**/*.yml" = "ansible";
            "**/host_vars/*.yaml" = "ansible";
            "**/host_vars/*.yml" = "ansible";
            "**/roles/**/*.yaml" = "ansible";
            "**/roles/**/*.yml" = "ansible";
          };
          autoSave = "onFocusChange";
          enableTrash = false;
          eol = "\n";
        };
        markdown = {
          updateLinksOnFileMove.enabled = "always";
          validate = {
            fileLinks = {
              enabled = true;
              markdownFragmentLinks = true;
            };
            fragmentLinks.enabled = true;
            referenceLinks.enabled = true;
          };
        };
        # Nix settings
        nix = {
          formatterPath = [
            "nixpkgs-fmt"
            "nixfmt"
            "treefmt"
            "--stdin"
            "{file}"
            "nix"
            "fmt"
            "--"
            "-"
          ];
          enableLanguageServer = true;
          serverPath = "nixd";
          serverSettings = {
            nixd = {
              formatting = {
                command = [
                  "nixpkgs-fmt"
                ];
              };
              # options = {
              #   # By default, this entriy will be read from `import <nixpkgs> { }`.
              #   # You can write arbitary Nix expressions here, to produce valid "options" declaration result.
              #   # Tip: for flake-based configuration, utilize `builtins.getFlake`
              #   nixos = {
              #     expr = "(builtins.getFlake \"/absolute/path/to/flake\").nixosConfigurations.<name>.options"
              #   };
              #   home-manager = {
              #     expr = "(builtins.getFlake \"/absolute/path/to/flake\").homeConfigurations.<name>.options"
              #   };
              #   # Tip: use ${workspaceFolder} variable to define path
              #   nix-darwin = {
              #     expr = "(builtins.getFlake \"${workspaceFolder}/path/to/flake\").darwinConfigurations.<name>.options"
              #   };
              # };
            };
          };
        };
        "redhat.telemetry.enabled" = false;
        terminal.integrated = {
          fontLigatures.enabled = true;
          minimumContrastRatio = 1;
        };
        window.titleBarStyle = "custom";
        workbench.colorTheme = "Catppuccin Mocha";
        workbench.preferredDarkColorTheme = "Catppuccin Mocha";
        workbench.preferredHighContrastColorTheme = "Catppuccin Frappé";
        workbench.preferredHighContrastLightColorTheme = "Catppuccin Latte";
        workbench.preferredLightColorTheme = "Catppuccin Latte";
        "workbench.iconTheme" = "catppuccin-mocha";
        "yaml.schemas" = {
          "file://${config.home.homeDirectory}/.vscode-oss/extensions/continue.continue/config-yaml-schema.json" = [
            ".continue/**/*.yaml"
          ];
        };
        github.copilot = {
          nextEditSuggestions.enabled = true;
          advanced = {
            # Enable GitHub Copilot
            github.copilot.enable = true;

            # Enable Copilot suggestions in comments
            github.copilot.suggestionMode = "inline"; # Options: "inline", "ghostText", "none"

            # Enable Copilot suggestion in strings
            github.copilot.enableInStringLiterals = true;

            # Enable Copilot suggestion in comments
            github.copilot.enableInComments = true;

            # Enable Copilot suggestion in documentation
            github.copilot.enableInDocumentation = true;

            # Control the delay before Copilot suggestion appear
            github.copilot.suggestionDelay = 150;

            # Enable Copilot for specific languages
            github.copilot.enableLanguages = {
              javascript = true;
              typescript = true;
              python = true;
              go = true;
              java = true;
              ruby = true;
              php = true;
              csharp = true;
              cpp = true;
              plaintext = true;
              markdown = true;
            };

            # Enable Copilot for specific file types
            github.copilot.enableFileType = {
              javascript = true;
              typescript = true;
              python = true;
              go = true;
              java = true;
              ruby = true;
              php = true;
              csharp = true;
              cpp = true;
              plaintext = true;
              markdown = true;
            };
          };
        };
      };
    };
  };
}
