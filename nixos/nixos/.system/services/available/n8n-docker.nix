{ config, pkgs, ... }:

{
  # Enable Docker/Podman for OCI containers
  virtualisation.oci-containers = {
    backend = "docker";
    containers.n8n = {
      image = "n8nio/n8n:latest";

      # Bind to localhost only - external access via separate ingress
      ports = [ "127.0.0.1:5678:5678" ];

      # Persist workflow data
      volumes = [
        "/var/lib/n8n:/home/node/.n8n"
      ];

      # Load secrets from env file (WEBHOOK_URL, N8N_ENCRYPTION_KEY, etc.)
      environmentFiles = [ "/etc/nixos/env" ];

      # Auto-restart on failure
      extraOptions = [
        "--pull=always"  # Always pull latest image on restart
      ];
    };
  };

  # Create data directory with correct ownership (n8n runs as uid 1000 in container)
  systemd.tmpfiles.rules = [
    "d /var/lib/n8n 0750 1000 1000 -"
  ];

  # Enable Docker service
  virtualisation.docker.enable = true;
}
