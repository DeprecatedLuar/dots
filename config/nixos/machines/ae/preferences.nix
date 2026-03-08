{ pkgs, ... }:

{
  #──[Packages]───────────────────────────────────────────────────────────────

  environment.systemPackages = with pkgs; [
    # Server-specific packages can go here if needed
  ];

  #──[Network]────────────────────────────────────────────────────────────────

  networking = {
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 80 443 8080 25565 1433 ];
  };

  services.tailscale.enable = true;

  services.zerotierone.enable = true;
  services.zerotierone.joinNetworks = [ "bb720a5aaec04de3" ];

  #──[Custom Services]────────────────────────────────────────────────────────

  # n8n Tailscale funnel service
  systemd.services.tailscale-funnel = {
    description = "n8n funnel";
    after = [ "network.target" "tailscaled.service" ];
    wants = [ "tailscaled.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.tailscale}/bin/tailscale funnel 5678";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}
