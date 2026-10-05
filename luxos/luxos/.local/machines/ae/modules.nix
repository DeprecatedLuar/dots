{ ... }:
{
  imports = [
    ./local/hardware-support
    ./local/tailscale-funnel.nix
    ./users/user
    ./unstable.nix
    ./local/preferences.nix
  ];
}
