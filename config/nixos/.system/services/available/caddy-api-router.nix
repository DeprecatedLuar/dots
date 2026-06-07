{ config, pkgs, mainUser, ... }:

{
  services.caddy = {
    enable = true;

    # Service reads from /etc/caddy/Caddyfile
    configFile = "/etc/caddy/Caddyfile";
  };

  # Create user config dir and symlink to /etc/caddy
  systemd.tmpfiles.rules = [
    # Create ~/.config/caddy/
    "d /home/${mainUser}/.config/caddy 0755 ${mainUser} users -"

    # Symlink /etc/caddy -> ~/.config/caddy/
    "L+ /etc/caddy - - - - /home/${mainUser}/.config/caddy"
  ];
}
