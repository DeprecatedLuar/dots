{ ... }:

let
  mainUser = "user";
  hostName = "ae";
  compositors = [ ];
  configDir = "/home/${mainUser}/.config/nixos";

in
{
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";

  imports = [

    #"${configDir}/system/gui/gui.nix"
   


    #dont touch
    "${configDir}/system/system.nix"
    "${configDir}/machines/${hostName}/default.nix"
    "${configDir}/users/${mainUser}.nix"

  ];

  networking.hostName = hostName;
  _module.args = { inherit mainUser hostName compositors; };
}
