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
    # tag = "${version}";
    hash = "sha256-NRKRROq6uxLlAHCtpT+s+eBVjFgf8qjjwlYGhdNApUs=";
  };

  vendorHash = "sha256-9xYy1Ep7bZ0nW63fmrxiqfOrHWt7Kcn+zGhcjBpdvYY=";

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
