{ ... }:
{
  imports = [
    ./services/tailscale-funnel.nix
    ./users/user
    ./nixpkgs.nix
    ./local/hardware.nix
    ./local/preferences.nix
  ];
}
