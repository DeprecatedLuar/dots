{ inputs, pkgs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
  tcpeek = inputs.tcpeek.packages.${system}.default;
  blsd = inputs.borderline-lsd.packages.${system}.default;

  configDir = ./config;
  kanataPort = 5828;
  session = "graphical-session.target";
in
{
  services.kanata = {
    enable = true;
    keyboards.vimsanity = {
      # whole dir so the (include vimsanity.kbd) resolves next to it
      configFile = "${configDir}/kanata/window-manager.kbd";
      port = kanataPort;
    };
  };

  systemd.user.services.blsd = {
    description = "blsd screen border overlay";
    after = [ session ];
    partOf = [ session ];
    wantedBy = [ session ];
    serviceConfig = {
      ExecStart = "${blsd}/bin/blsd-shell";
      Restart = "always";
      RestartSec = "1";
    };
  };

  systemd.user.services.tcpeek = {
    description = "tcpeek kanata layer listener";
    after = [ "blsd.service" ];
    wants = [ "blsd.service" ];
    partOf = [ session ];
    wantedBy = [ session ];
    # events run via `sh -c`; failures reported via notify-send
    path = [ blsd pkgs.bash pkgs.libnotify ];
    environment.TCPEEK_CONFIG_DIR = "${configDir}/tcpeek";
    serviceConfig = {
      ExecStart = "${tcpeek}/bin/tcpeek";
      Restart = "always";
      RestartSec = "1";
    };
  };
}
