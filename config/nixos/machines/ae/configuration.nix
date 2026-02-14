{ ... }:

let
  mainUser = "user";
  hostName = "ae";
  compositors = [ ]; # Headless server - no GUI
  configDir = "/home/${mainUser}/.config/nixos";

in
{
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";

  imports = [

    # GUI modules - won't activate due to empty compositors
    "${configDir}/system/gui/gui.nix"
    # Intentionally NOT importing gaming.nix - server doesn't need it


    #dont touch
    "${configDir}/system/system.nix"
    "${configDir}/machines/${hostName}/default.nix"
    "${configDir}/users/${mainUser}.nix"

  ];

  networking.hostName = hostName;
  _module.args = { inherit mainUser hostName compositors; };
}
