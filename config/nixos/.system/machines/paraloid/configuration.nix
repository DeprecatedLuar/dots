{ ... }:

let
  mainUser = "luar";
  hostName = "paraloid";
  compositors = [ "hyprland" "niri" "openbox" "i3" "xfce" ]; # "hyprland", "niri", "openbox"
  configDir = "/home/${mainUser}/.config/nixos";
  sysDir = "${configDir}/.system";
in
{
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";

  imports = [
    "${sysDir}/gui/gui.nix"
    "${sysDir}/gui/gaming.nix"
    "${sysDir}/system.nix"
    "${sysDir}/machines/${hostName}/default.nix"
    "${sysDir}/users/${mainUser}.nix"
  ];

  networking.hostName = hostName;
  _module.args = { inherit mainUser hostName compositors; };
}
