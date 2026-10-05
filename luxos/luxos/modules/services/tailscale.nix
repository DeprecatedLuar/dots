{ pkgs, ... }:

let
  operator = "luar";
in
{
  environment.systemPackages = [
    pkgs.tailscale
    pkgs.trayscale
  ];

  services.tailscale = {
    enable = true;
    extraSetFlags = [
      "--accept-dns=false"
      "--operator=${operator}"
    ];
  };

  systemd.user.services.trayscale = {
    description = "Trayscale tray icon for Tailscale";
    documentation = [ "https://github.com/DeedleFake/trayscale" ];
    after = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    bindsTo = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.trayscale}/bin/trayscale --hide-window";
      Restart = "on-failure";
      RestartSec = "5";
    };
  };
}
