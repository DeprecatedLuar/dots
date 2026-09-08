# Auto-generated from machine.toml - DO NOT EDIT
# Paths are relative to /etc/nixos/luxos, where self-heal copies this file.
# Edit machine.toml instead and run: sudo nixos-rebuild switch

{ ... }:

let
  mainUser = "luar";
  hostName = "paraloid";
in
{
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";
  system.stateVersion = "25.05";

  imports = [
    ./framework/system.nix
    ./config/machines/paraloid/default.nix
    ./config/machines/paraloid/users/luar.nix
    ./framework/modules/gaming.nix
    ./config/machines/paraloid/modules/desktops/hyprland.nix
    ./config/machines/paraloid/modules/desktops/xfce.nix
    ./config/machines/paraloid/modules/greeters/ly.nix
    ./config/machines/paraloid/modules/desktop-apps.nix
  ];

  networking.hostName = hostName;
  _module.args = { inherit mainUser hostName; };
}
