{ buildGoModule, pkgs, lib, ... }: let
  # pversion = "${version}" ? "1.1";
  pversion = "1.1";
in
buildGoModule {
  pname = "bshchk";
  version = "${pversion}";

  src = pkgs.fetchFromGitHub {
    owner = "b1ek";
    repo = "bshchk";
    rev = "${pversion}";
    hash = "sha256-sncLKkcnFZd3Tlxpuajy0PWJ7ARo8RM1jpaP1gIDl28=";
  };

  ldflags = [
    "-X main.version=${pversion}"
  ];

  vendorHash = "sha256-k3I7PnzK5rF2BcDSadNRXI7LrK0VnZfX4eNxCvwt3uc=";

  meta = {
    description = "A runtime bash dependency checker";
    homepage = "https://github.com/b1ek/bshchk";
    license = lib.licenses.gpl3;
    # maintainers = with lib.maintainers; [ kalbasit ];
  };
}
