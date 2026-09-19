{ ... }:
{
  imports = [
    ./services/nginx.nix
    ./services/caddy.nix
    ./users/luar
    ./nixpkgs.nix
    ./local/hardware.nix
    ./local/preferences.nix
  ];
}
