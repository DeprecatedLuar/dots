{ ... }:
{
  imports = [
    ./local/hardware-support
    ./services/tailscale-funnel.nix
    ./users/user
    ./unstable.nix
    ./local/preferences.nix
  ];
}
