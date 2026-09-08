# Auto-generated from local/ - DO NOT EDIT
# Drop a .nix file in local/ and run: sudo nixos-rebuild switch

{ ... }:

{
  imports = [
    ./local/hardware.nix
    ./local/packages.nix
    ./local/preferences.nix
  ];
}
