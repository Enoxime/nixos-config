{ pkgs, lib, ... }: {
  imports = [
    ./vscodium.nix
  ];

  home.packages = with pkgs; [
    amber-lang
    # bshchk
    (buildGoModule rec {
      pname = "bshchk";
      version = "1.1";

      src = pkgs.fetchFromGitHub {
        owner = "b1ek";
        repo = "bshchk";
        rev = "${version}";
        hash = "sha256-sncLKkcnFZd3Tlxpuajy0PWJ7ARo8RM1jpaP1gIDl28=";
      };

      ldflags = [
        "-X main.version=${version}"
      ];

      vendorHash = "sha256-k3I7PnzK5rF2BcDSadNRXI7LrK0VnZfX4eNxCvwt3uc=";

      meta = {
        description = "A runtime bash dependency checker";
        homepage = "https://github.com/b1ek/bshchk";
        license = lib.licenses.gpl3;
        # maintainers = with lib.maintainers; [ kalbasit ];
      };
    })
    pipenv
    nodejs # Needed for pre-commit for whatever reasons
    shellcheck
    shfmt
  ];
}
