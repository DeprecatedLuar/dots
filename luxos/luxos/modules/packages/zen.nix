{ inputs, pkgs, ... }:

{
  flake-file.inputs.zen-browser = {
    url = "github:youwen5/zen-browser-flake";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  environment.systemPackages = [
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
