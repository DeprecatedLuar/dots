{ inputs, pkgs, ... }:

{
  flake-file.inputs.squix = {
    url = "github:eduardofuncao/squix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  environment.systemPackages = [
    inputs.squix.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
