{ ... }:
{
  imports = [
    ./local/hardware-support
    ./services/nginx.nix
    ./services/caddy.nix
    ./users/luar
    ./unstable.nix
    ./local/preferences.nix
  ];
}
