{ pkgs, ... }:

{
  flake-file.inputs.unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  virtualisation.docker.enable = true;
  virtualisation.docker.package = pkgs.unstable.docker;
}
