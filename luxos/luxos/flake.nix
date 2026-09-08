# Auto-generated from channels.toml - DO NOT EDIT
# Edit channels.toml and run: sudo nixos-rebuild switch

{
  description = "luxos machine configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";  # base channel: stable
    unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, unstable, ... }@inputs:
  let
    system = "x86_64-linux";

    # Exposes every declared channel as pkgs.<channel>.<package>, so a package
    # reference always states which channel it came from. The base channel
    # aliases prev instead of re-importing itself (pkgs already is that
    # channel); the others inherit config so allowUnfree and friends carry
    # over rather than being restated here.
    channelOverlay = final: prev: {
      stable = prev;
      unstable = import unstable { inherit (prev) system config; };
    };

    mkHost = hostName: nixpkgs.lib.nixosSystem {
      inherit system;
      # frameworkModules lets a machine module reach a framework module by
      # name (frameworkModules + "/wayland.nix") regardless of how deep the
      # machine module is nested — the two repos aren't nested relative to
      # each other, so no relative path between them can exist.
      specialArgs = { inherit inputs hostName; frameworkModules = ./framework/modules; };
      modules = [
        ./configuration.nix
        { nixpkgs.overlays = [ channelOverlay ]; }
      ];
    };
  in {
    # One entry per machine directory under .system/machines/ — enumerated,
    # never hand-maintained.
    nixosConfigurations = {
      ae = mkHost "ae";
      nuremberg = mkHost "nuremberg";
      paraloid = mkHost "paraloid";
    };
  };
}
