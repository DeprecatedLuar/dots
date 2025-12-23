{ ... }:

let
  mainUser = "luar";
  hostName = "paraloid";
  configDir = "/home/${mainUser}/.config/nixos";
    
in
{
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.variant = "";
  
  imports = [

    "${configDir}/system.nix"
    "${configDir}/gui.nix"
#   "${configDir}/cli.nix" 

    "${configDir}/machines/${hostName}"
    ./hardware-configuration.nix  
  ];

  networking.hostName = hostName;
  _module.args = { inherit mainUser hostName; };
}
