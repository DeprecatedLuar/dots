{ ... }:

let
  mainUser = "luar";
  hostName = "paraloid";
  compositors = [ "hyprland" "niri" "xfce" ]; # "hyprland", "niri", "xfce"
  configDir = "/home/${mainUser}/.config/nixos";

in
{
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.variant = "";

  imports = [

    "${configDir}/system.nix"
    "${configDir}/gui/gui.nix"
    "${configDir}/gui/gaming.nix"
    "${configDir}/users/${mainUser}.nix"
    #"${configDir}/cli.nix"

    "${configDir}/machines/${hostName}/default.nix" #don't touch
  ];

  networking.hostName = hostName;
  _module.args = { inherit mainUser hostName compositors; };
}
