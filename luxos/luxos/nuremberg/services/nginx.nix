{ mainUser, hostName, ... }:

{
  services.nginx = {
    enable = true;

    # Recommended settings
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    # Disable access log to avoid permission issues
    appendHttpConfig = ''
      access_log off;
    '';

    # Virtual hosts
    virtualHosts = {
      "n8n.theparaloid.com" = {
        enableACME = true;
        forceSSL = true;

        extraConfig = ''
          client_max_body_size 100M;
        '';

        locations."/" = {
          proxyPass = "http://localhost:5678";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;

            proxy_read_timeout 80s;
            proxy_connect_timeout 80s;
            proxy_send_timeout 80s;

            chunked_transfer_encoding off;
            proxy_buffering off;
            proxy_cache off;
          '';
        };
      };

      "api.theparaloid.com" = {
        enableACME = true;
        forceSSL = true;

        extraConfig = ''
          client_max_body_size 100M;
        '';

        locations."/" = {
          proxyPass = "http://localhost:8888";
          extraConfig = ''
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
      };
    };
  };

  # ACME configuration for Let's Encrypt
  security.acme = {
    acceptTerms = true;
    defaults.email = "rlas00sil@gmail.com";
  };

  # Open HTTP and HTTPS ports
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
