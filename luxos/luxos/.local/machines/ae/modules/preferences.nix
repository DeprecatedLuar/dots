{ pkgs, ... }:

{
  #──[Network]────────────────────────────────────────────────────────────────

  networking = {
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 80 443 8080 25565 1433 ];
  };

  services.zerotierone.enable = true;
  services.zerotierone.joinNetworks = [ "bb720a5aaec04de3" ];

}
