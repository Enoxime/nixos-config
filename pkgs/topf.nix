{
  buildGoModule,
  pkgs,
  lib,
  age,
  sops,
  vals,
  ...
}: let
  pversion = "0.6.0";
in
buildGoModule {
  pname = "topf";
  version = "${pversion}";

  src = pkgs.fetchFromGitHub {
    owner = "postfinance";
    repo = "topf";
    # rev = "${pversion}";
    tag = "v${pversion}";
    hash = "sha256-NRKRROq6uxLlAHCtpT+s+eBVjFgf8qjjwlYGhdNApUs=";
  };

  vendorHash = "sha256-9xYy1Ep7bZ0nW63fmrxiqfOrHWt7Kcn+zGhcjBpdvYY=";

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
