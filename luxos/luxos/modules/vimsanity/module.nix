{ inputs, pkgs, ... }:

{
  flake-file.inputs.tcpeek = {
    url = "github:DeprecatedLuar/tcpeek";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake-file.inputs.borderline-lsd = {
    url = "github:DeprecatedLuar/borderline-lsd";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  environment.systemPackages = [
    inputs.tcpeek.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.borderline-lsd.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
