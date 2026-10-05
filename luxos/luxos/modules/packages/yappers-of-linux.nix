{ inputs, pkgs, ... }:

{
  flake-file.inputs.yappers-of-linux = {
    url = "github:DeprecatedLuar/yappers-of-linux";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  environment.systemPackages = [
    inputs.yappers-of-linux.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
