{
  buildGoModule,
  pkgs,
  lib,
  age,
  sops,
  vals,
  ...
}: let
  version = "v0.6.2";
in
buildGoModule {
  pname = "topf";
  version = "${version}";

  src = pkgs.fetchFromGitHub {
    owner = "postfinance";
    repo = "topf";
    rev = "${version}";
    hash = "sha256-frUyZtpA0iyFwHxlN5SqZ0WFfU4sMalmdkHtulg+B3I=";
  };

  vendorHash = "sha256-VLZLPM1/a1Lf5ggk4pwB/AL+Drrdfmm3f9DYjvpBKcA=";

  ldflags = [
    "-w -X main.version=${version}"
  ];

  depsBuildBuild = [
    age
    sops
    vals
  ];

  meta = {
    description = "Talos orchestrator by PostFinance";
    homepage = "https://github.com/postfinance/topf";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ pouet ];
  };
}
