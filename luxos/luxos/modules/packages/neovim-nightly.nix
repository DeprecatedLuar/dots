{ inputs, pkgs, ... }:

{
  flake-file.inputs.neovim-nightly-overlay = {
    url = "github:nix-community/neovim-nightly-overlay";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  environment.systemPackages = [
    inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
