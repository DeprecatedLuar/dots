{ pkgs, ... }:

{
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
