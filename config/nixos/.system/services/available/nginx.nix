{ mainUser, hostName, ... }:

{
  services.nginx = {
    enable = true;

    # Allow traditional config file management
    # Site configs can be managed in /etc/nginx/sites-available/
    # and symlinked to /etc/nginx/sites-enabled/
  };

  # Open HTTP and HTTPS ports
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
