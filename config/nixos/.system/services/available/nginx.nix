{ mainUser, hostName, ... }:

{
  services.nginx = {
    enable = true;

    # Allow traditional config file management via sites-enabled
    appendHttpConfig = ''
      include /etc/nginx/sites-enabled/*;
    '';
  };

  # Create sites-available and sites-enabled directories
  systemd.tmpfiles.rules = [
    "d /etc/nginx 0755 root root -"
    "d /etc/nginx/sites-available 0755 root root -"
    "d /etc/nginx/sites-enabled 0755 root root -"
  ];

  # Open HTTP and HTTPS ports
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
