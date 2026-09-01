{ ... }:

{
  services.n8n = {
    enable = true;
    openFirewall = true;
  };

  networking.firewall.allowedTCPPorts = [ 5678 ];
}
