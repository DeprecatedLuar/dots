{ config, pkgs, ... }:

{
  services.caddy = {
    enable = true;
    configFile = "/etc/caddy/Caddyfile";
  };

  # Create /etc/caddy directory
  systemd.tmpfiles.rules = [
    "d /etc/caddy 0755 caddy caddy -"
  ];
}
