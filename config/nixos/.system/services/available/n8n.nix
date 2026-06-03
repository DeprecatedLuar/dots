{ mainUser, hostName, ... }:

{
  services.n8n = {
    enable = true;
    environment = {
      N8N_HOST = "0.0.0.0";
      N8N_PORT = "5678";
      # Data persists in /var/lib/n8n by default
    };
  };

  # Open firewall for local testing
  networking.firewall.allowedTCPPorts = [ 5678 ];
}
